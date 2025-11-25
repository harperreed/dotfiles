---
name: building-multiagent-systems
description: Use when designing or implementing systems with orchestrators, sub-agents, and tool coordination - guides through architecture patterns, coordination mechanisms, and production-ready implementations for multi-agent workflows
---

# Building Multi-Agent, Tool-Using Agentic Systems

## Overview

Use this skill when you need to design or implement a system where multiple AI agents work together using tools to accomplish complex tasks. This covers orchestrator-subagent architectures, coordination patterns, tool management, and production hardening.

**When to use this skill:**
- Designing a multi-agent system from scratch
- Adding multi-agent capabilities to an existing system
- Debugging or improving multi-agent coordination
- Implementing specific patterns (fan-out/fan-in, pipelines, map-reduce, peer collaboration)
- Building tool-using agents that need to coordinate resource access

**This skill is language-agnostic** - it teaches universal patterns that work in any programming environment (TypeScript, Python, Go, Rust, etc.)

## CRITICAL: Initial Discovery

Before providing any architectural guidance, you MUST ask these discovery questions to understand the user's needs:

### Discovery Questions (Ask ALL of these)

**1. Starting Point**
   - [ ] Green field (designing from scratch)
   - [ ] Adding multi-agent to existing system
   - [ ] Fixing/improving existing multi-agent system

**2. Primary Use Case**
   - [ ] Parallel independent work (code review, file analysis)
   - [ ] Sequential pipeline (design → implement → test)
   - [ ] Recursive delegation (task breakdown)
   - [ ] Peer collaboration (multi-model consensus)
   - [ ] Work queue (batch processing)
   - [ ] Other: _______

**3. Scale Expectations**
   - [ ] Small (2-5 agents max)
   - [ ] Medium (10-50 agents)
   - [ ] Large (100+ agents, need resource limits)

**4. State Requirements**
   - [ ] Stateless (each run independent)
   - [ ] Session-based (resume within session)
   - [ ] Persistent (survive crashes, long-running workflows)

**5. Tool Coordination Needs**
   - [ ] No shared resources (agents work independently)
   - [ ] Read-only shared resources (multiple agents read same data)
   - [ ] Write coordination needed (locks, transactions)
   - [ ] Rate-limited APIs (need throttling across agents)

**6. Existing Constraints**
   - What language/framework are you using?
   - Any existing agent or orchestration libraries?
   - Performance/cost constraints?
   - Compliance or security requirements?

## Architecture Foundations

After gathering requirements, present these foundational patterns:

### Core Architectural Patterns

**1. Event-Sourcing for Audit Trail**

All state changes should be events that can reconstruct system state:

```pseudocode
# Events are immutable records
events = [
  { type: "agent:spawned", agentId, parentId, timestamp },
  { type: "agent:started", agentId, task },
  { type: "tool:executed", agentId, tool, result },
  { type: "agent:completed", agentId, result, cost }
]

# State is derived, not stored
function getCurrentState(events):
  state = {}
  for event in events:
    state = applyEvent(state, event)
  return state
```

**Benefits:**
- Complete audit trail of all agent interactions
- Replay capability for debugging
- Resume from any point in execution
- Multiple views of same data (different interfaces)

---

**2. Hierarchical IDs for Delegation Tracking**

Thread/agent IDs should encode the delegation hierarchy:

```
session         (root orchestrator)
session.1       (first child)
session.2       (second child)
session.1.1     (child of session.1)
session.1.2     (another child of session.1)
session.2.1     (child of session.2)
```

**Benefits:**
- Instantly see delegation tree from ID
- Easy to find all descendants: IDs starting with "session.1"
- Cost aggregation: roll up all "session.1.*" costs
- Debug visualization: render tree from IDs

---

**3. Agent State Machines**

Every agent should have explicit states and valid transitions:

```
States:
  idle → thinking → streaming → tool_execution → idle → stopped

Valid Transitions:
  idle → thinking (start work)
  thinking → streaming (receiving LLM response)
  streaming → tool_execution (tools detected in response)
  tool_execution → thinking (continue after tools complete)
  * → stopped (abort or completion)

Terminal State:
  stopped (no transitions out)
```

**Implementation pattern:**

```pseudocode
class Agent:
  state = "idle"

  function transitionTo(newState):
    validTransitions = {
      "idle": ["thinking", "stopped"],
      "thinking": ["streaming", "stopped"],
      "streaming": ["tool_execution", "idle", "stopped"],
      "tool_execution": ["thinking", "stopped"],
      "stopped": []
    }

    if newState not in validTransitions[state]:
      throw InvalidTransitionError(state, newState)

    state = newState
    emit("state:changed", { agentId, oldState: state, newState, timestamp })
```

---

**4. Communication Mechanisms**

Choose based on your language/environment:

**Pattern A: EventEmitter (JavaScript/TypeScript/Node.js)**

```pseudocode
class Agent extends EventEmitter:
  function emitStateChange(newState):
    this.emit("state:changed", {
      agentId: this.id,
      state: newState,
      timestamp: now()
    })

  function emitToolExecution(tool, input):
    this.emit("tool:executing", {
      agentId: this.id,
      tool: tool,
      input: input
    })

# Parent listens to child
class Orchestrator:
  function setupChildListeners(child):
    child.on("state:changed", (event) => {
      log("Child " + event.agentId + " → " + event.state)
    })

    child.on("tool:executing", (event) => {
      log("Child using tool: " + event.tool)
    })

    child.on("error", (error) => {
      this.handleChildError(child.id, error)
    })
```

**Pattern B: Channels (Go, Rust)**

```pseudocode
type Agent struct {
  id string
  parentId string

  events chan Event
  commands chan Command
  results chan Result
}

# Parent sends command
function sendCommand(parent, childId, command):
  child = parent.children[childId]
  select:
    case child.commands <- command:
      return nil
    case <-timeout(5 * Second):
      return TimeoutError

# Child sends result
function sendResult(child, result):
  parent = child.getParent()
  select:
    case parent.results <- result:
      return nil
    case <-timeout(5 * Second):
      return TimeoutError

# Parent collects results
function gatherResults(parent, childIds):
  results = []
  for _ in childIds:
    select:
      case result := <-parent.results:
        results.append(result)
      case <-timeout(30 * Second):
        return results, TimeoutError
  return results, nil
```

**Pattern C: Async/Await (Python, modern JS)**

```pseudocode
class Agent:
  async def execute(task):
    self.emit("started", task)
    result = await self.llm.query(task.prompt)
    self.emit("completed", result)
    return result

# Parent awaits child
class Orchestrator:
  async def delegate(task):
    child = self.spawnAgent()
    result = await child.execute(task)
    await child.stop()
    return result
```

**Choose communication pattern based on:**
- Language features (EventEmitter in Node, channels in Go)
- Performance needs (channels for true parallelism)
- Simplicity (async/await for sequential workflows)

---

## Agent Spawning Patterns

### Pattern 1: Declarative (Task-Based)

Agents spawn automatically when tasks are assigned with special format:

```pseudocode
# Create task with special assignee format
task = createTask({
  id: "task-123",
  instructions: "Analyze error handling patterns",
  assignedTo: "new:specialist;model:fast",  # Magic format triggers spawn
  context: { files: ["src/**/*.ts"] }
})

# System detects "new:" prefix and spawns agent
function handleTaskAssignment(task):
  if task.assignedTo.startsWith("new:"):
    spec = parseNewAgentSpec(task.assignedTo)
    agent = spawnAgent({
      persona: spec.persona,
      model: spec.model,
      task: task
    })
    task.assignedTo = agent.id  # Update with actual agent ID
```

**NewAgentSpec format:**
```
new:persona_name;model:model_id
new:specialist;model:sonnet
new:research-assistant;model:gpt-4
```

**When to use:**
- Orchestrators that operate at task level
- Declarative workflows
- Dynamic delegation based on task requirements

---

### Pattern 2: Programmatic (Direct Spawning)

Explicit agent creation with full control:

```pseudocode
class Session:
  function spawnAgent(config):
    # Generate hierarchical thread ID
    threadId = config.threadId || this.createDelegateThread().id

    # Create child agent
    agent = new Agent({
      id: generateAgentId(),
      sessionId: this.sessionId,
      threadId: threadId,
      persona: loadPersona(config.persona),
      model: config.model,

      # Inherit from parent
      tools: this.toolRegistry,
      permissions: this.permissions.createChildScope(),
      eventStore: this.eventStore
    })

    # Register
    this.agents[agent.id] = agent

    return agent

# Usage
child = session.spawnAgent({
  persona: "code-analyzer",
  model: "haiku",
  threadId: "session.1"  # Explicit thread assignment
})

await child.initialize()
result = await child.start({ prompt: "Analyze complexity..." })
await child.stop()
```

**When to use:**
- Need full lifecycle control
- Complex initialization requirements
- Custom tool/permission configuration
- Testing scenarios

---

### Pattern 3: Pool-Based (Worker Pool)

Pre-spawn workers, reuse for multiple tasks:

```pseudocode
class AgentPool:
  workers = []
  availableWorkers = Queue()

  function initialize(size):
    for i in range(size):
      worker = spawnAgent({ persona: "worker", model: "fast" })
      workers.append(worker)
      availableWorkers.enqueue(worker)

  async function execute(task):
    # Wait for available worker
    worker = await availableWorkers.dequeue()

    try:
      result = await worker.execute(task)
      return result
    finally:
      # Return to pool
      availableWorkers.enqueue(worker)

  async function shutdown():
    await Promise.all(workers.map(w => w.stop()))

# Usage
pool = AgentPool()
pool.initialize(size=5)

tasks = loadTasks()
results = await Promise.all(tasks.map(t => pool.execute(t)))

await pool.shutdown()
```

**When to use:**
- High-frequency small tasks
- Agent initialization is expensive
- Need to limit concurrent agents
- Long-running system

---

## Coordination Patterns (Comprehensive)

### Pattern 1: Fan-Out/Fan-In (Parallel Independent Work)

**Use Case:** Code review, parallel file analysis, multi-model consensus

```pseudocode
async function parallelWork(items):
  # 1. Fan-out: Spawn agents for each item
  agents = items.map(item =>
    spawnAgent({
      persona: getPersonaForItem(item),
      model: "fast"
    })
  )

  # 2. Execute in parallel
  tasks = agents.map(async (agent, i) => {
    try:
      return await agent.execute(items[i])
    catch error:
      return { error: error, item: items[i] }
  })

  # 3. Fan-in: Wait for all
  results = await Promise.all(tasks)  # Fail-fast
  # OR
  results = await Promise.allSettled(tasks)  # Continue on error

  # 4. Clean up
  await Promise.all(agents.map(a => a.stop()))

  # 5. Aggregate
  return aggregateResults(results)
```

**Variations:**

**A. Batching (to limit concurrent agents):**

```pseudocode
BATCH_SIZE = 10

batches = chunk(items, BATCH_SIZE)
allResults = []

for batch in batches:
  agents = batch.map(item => spawnAgent(...))
  batchResults = await Promise.all(agents.map(a => a.execute()))
  allResults.push(...batchResults)
  await Promise.all(agents.map(a => a.stop()))

return allResults
```

**B. Timeout per agent:**

```pseudocode
async function executeWithTimeout(agent, task, timeout):
  return Promise.race([
    agent.execute(task),
    sleep(timeout).then(() => { throw TimeoutError() })
  ])

results = await Promise.all(
  agents.map((a, i) => executeWithTimeout(a, items[i], 30000))
)
```

**🚨 CRITICAL GOTCHAS:**

1. **Orphaned children:** If orchestrator is aborted, children may keep running
   - **Fix:** Implement cascading stop (see Lifecycle section)

2. **Resource exhaustion:** Spawning 1000 agents at once
   - **Fix:** Use batching or worker pool pattern

3. **Cost explosion:** N agents × cost per agent
   - **Fix:** Use cheap models (Haiku, GPT-4o-mini) for simple work

4. **No result if one agent hangs**
   - **Fix:** Add timeouts to each agent execution

---

### Pattern 2: Sequential Pipeline

**Use Case:** Multi-stage transformations (design → implement → test), progressive refinement

```pseudocode
stages = [
  { name: "design", persona: "architect", model: "smart" },
  { name: "implement", persona: "coder", model: "fast" },
  { name: "test", persona: "qa", model: "fast" },
  { name: "refactor", persona: "senior-dev", model: "smart" }
]

async function executePipeline(stages, initialContext):
  context = initialContext

  for stage in stages:
    # Spawn agent for stage
    agent = spawnAgent({
      persona: stage.persona,
      model: stage.model
    })

    # Execute with accumulated context
    result = await agent.execute({
      prompt: stage.instructions,
      context: context
    })

    # Merge result into context
    context = mergeContexts(context, result)

    # Clean up
    await agent.stop()

    # Emit progress
    emit("stage:completed", {
      stage: stage.name,
      result: result
    })

  return context
```

**With checkpointing (survive failures):**

```pseudocode
async function executePipelineWithCheckpoints(stages, initialContext):
  context = initialContext

  for stage in stages:
    # Check for existing checkpoint
    checkpoint = await loadCheckpoint(stage.name)
    if checkpoint.exists:
      log("Resuming from checkpoint: " + stage.name)
      context = checkpoint.context
      continue

    # Execute stage
    agent = spawnAgent(stage)
    result = await agent.execute(stage.instructions, context)
    context = mergeContexts(context, result)
    await agent.stop()

    # Save checkpoint
    await saveCheckpoint(stage.name, {
      context: context,
      timestamp: now()
    })

  return context
```

**🚨 CRITICAL GOTCHAS:**

1. **Sequential bottleneck:** Pipeline is as slow as slowest stage
   - **Fix:** Parallelize independent stages where possible

2. **Early failure blocks pipeline:** First stage fails, rest never run
   - **Fix:** Add checkpointing + retry logic

3. **Context growth:** Each stage adds to context, becomes huge
   - **Fix:** Prune context between stages, keep only essential data

---

### Pattern 3: Recursive Delegation

**Use Case:** Complex task breakdown, hierarchical planning

```pseudocode
class OrchestratorAgent:
  async def execute(task):
    # 1. Analyze task complexity
    complexity = this.assessComplexity(task)

    if complexity.isSimple:
      # Leaf: Execute directly
      return await this.executeDirect(task)

    # 2. Break down into subtasks
    subtasks = await this.breakDown(task)

    # 3. Delegate to children
    results = []
    for subtask in subtasks:
      if subtask.isComplex:
        # Recursive: spawn another orchestrator
        child = spawnAgent({
          persona: "orchestrator",
          model: "smart"
        })
      else:
        # Leaf: spawn specialist
        child = spawnAgent({
          persona: subtask.persona,
          model: "fast"
        })

      result = await child.execute(subtask)
      results.push(result)
      await child.stop()

    # 4. Synthesize results
    return this.synthesize(results)
```

**Thread ID tracking:**

```
session         (root orchestrator)
  ├─ session.1     (child orchestrator for subtask A)
  │   ├─ session.1.1  (specialist: design)
  │   ├─ session.1.2  (specialist: implement)
  │   └─ session.1.3  (specialist: test)
  └─ session.2     (child orchestrator for subtask B)
      ├─ session.2.1  (specialist: research)
      └─ session.2.2  (specialist: document)
```

**Cost aggregation (bubbles up):**

```pseudocode
function getTotalCost(agentId):
  ownCost = sumLLMCalls(agentId)

  # Find all descendants
  children = getAllAgents().filter(a => a.id.startsWith(agentId + "."))
  childrenCost = children.map(c => getTotalCost(c.id)).sum()

  return ownCost + childrenCost
```

**🚨 CRITICAL GOTCHAS:**

1. **Infinite recursion:** Orchestrator keeps breaking down forever
   - **Fix:** Add max depth limit (e.g., 5 levels)

2. **Incorrect cost aggregation:** Lost track of child costs
   - **Fix:** Use hierarchical ID-based aggregation (shown above)

3. **Deep hierarchies hard to debug:** Can't see what's happening
   - **Fix:** Emit events at each level, visualize tree

---

### Pattern 4: Work-Stealing Queue

**Use Case:** Large batches of independent tasks (1000+ files to analyze)

```pseudocode
class WorkQueue:
  tasks = Channel()
  results = Channel()
  workers = []

  function start(numWorkers):
    # Spawn worker agents
    for i in range(numWorkers):
      worker = spawnAgent({ persona: "worker", model: "fast" })
      workers.append(worker)

      # Each worker pulls from shared queue
      asyncRun(async () => {
        while true:
          task = await tasks.receive()
          if task == POISON_PILL:
            break

          try:
            result = await worker.execute(task)
            results.send({ success: true, result: result })
          catch error:
            results.send({ success: false, error: error, task: task })
      })

  function submit(task):
    tasks.send(task)

  async function shutdown():
    # Send poison pills
    for _ in workers:
      tasks.send(POISON_PILL)

    # Wait for workers to finish
    await Promise.all(workers.map(w => w.stop()))

# Usage
queue = WorkQueue()
queue.start(numWorkers=10)

items = loadItems()  # 1000 items
for item in items:
  queue.submit(item)

# Collect results
results = []
for _ in items:
  result = await queue.results.receive()
  results.append(result)

await queue.shutdown()
```

**🚨 CRITICAL GOTCHAS:**

1. **No priority:** All tasks treated equally (FIFO)
   - **Fix:** Use priority queue instead of simple channel/queue

2. **Unbalanced work:** Some tasks take 1s, others take 60s
   - **Fix:** Dynamic worker pool that adjusts based on load

3. **No retry on failure:** Worker fails, task is lost
   - **Fix:** Track failed tasks, resubmit to queue

---

### Pattern 5: Map-Reduce

**Use Case:** Data processing at scale, pattern extraction across large codebase

```pseudocode
async function mapReduce(items, mapFn, reduceFn):
  # Map Phase: Spawn cheap agents
  mapResults = await Promise.all(
    items.map(async item => {
      agent = spawnAgent({
        persona: "mapper",
        model: "cheap"  # Haiku, GPT-4o-mini
      })

      try:
        result = await agent.execute(mapFn, item)
        return result
      finally:
        await agent.stop()
    })
  )

  # Filter out failures
  successfulResults = mapResults.filter(r => !r.error)

  # Reduce Phase: Single smart agent
  reduceAgent = spawnAgent({
    persona: "reducer",
    model: "smart"  # Sonnet, GPT-4
  })

  try:
    finalResult = await reduceAgent.execute(reduceFn, successfulResults)
    return finalResult
  finally:
    await reduceAgent.stop()

# Example: Analyze error handling across codebase
errorPatterns = await mapReduce(
  sourceFiles,                              # Items
  async file => this.analyzeFile(file),     # Map: per-file analysis
  async results => this.synthesize(results) # Reduce: aggregate patterns
)
```

**Cost optimization:**

| Phase | Model Choice | Reasoning |
|-------|--------------|-----------|
| Map | Cheap (Haiku, GPT-4o-mini) | Many simple tasks, low complexity |
| Reduce | Smart (Sonnet, GPT-4) | Single complex synthesis, high complexity |

**Total cost:**
```
Cost = (N_items × cost_cheap) + (1 × cost_smart)

Example with 100 files:
  Map:    100 × $0.01 = $1.00
  Reduce: 1 × $0.15 = $0.15
  Total: $1.15

vs all smart model:
  100 × $0.15 = $15.00 (13x more expensive!)
```

**🚨 CRITICAL GOTCHAS:**

1. **Reduce bottleneck:** All results fed to single agent
   - **Fix:** Hierarchical reduce (tree structure)

2. **Reduce context too large:** 1000 map results don't fit in context
   - **Fix:** Pre-aggregate in batches, then final reduce

---

### Pattern 6: Peer Collaboration (LLM Council)

**Use Case:** Multi-perspective analysis, bias reduction, consensus building

**IMPORTANT:** This is NOT hierarchical sub-agents! It's peer-based multi-model orchestration.

```pseudocode
async function llmCouncil(query):
  # Stage 1: Independent Responses (NO parent-child!)
  councilModels = [
    "openai/gpt-4",
    "anthropic/claude-sonnet",
    "google/gemini-pro",
    "xai/grok"
  ]

  responseTasks = councilModels.map(model =>
    callModel(model, query)
  )
  responses = await Promise.all(responseTasks)

  # Stage 2: Anonymized Peer Review
  # Each model ranks others WITHOUT knowing which is which
  labels = ["A", "B", "C", "D"]
  anonymized = zip(labels, responses)

  rankingTasks = councilModels.map(model =>
    callModel(model, createRankingPrompt(anonymized))
  )
  rankings = await Promise.all(rankingTasks)

  # Stage 3: Chairman Synthesis
  chairman = "google/gemini-pro"  # Can be any model
  finalAnswer = await callModel(chairman, {
    query: query,
    responses: responses,
    rankings: rankings
  })

  return {
    stage1_responses: responses,
    stage2_rankings: rankings,
    stage3_synthesis: finalAnswer,
    consensus: calculateConsensus(rankings)
  }
```

**Key differences from other patterns:**

| Aspect | LLM Council | Traditional Sub-Agents |
|--------|-------------|------------------------|
| Relationship | Peer-based | Hierarchical |
| Communication | Independent API calls | Event-based/channels |
| State | Stateless | Event-sourced |
| Coordination | Sequential stages | Promise chains |
| Cost | 3N+1 calls (expensive!) | N calls |

**🚨 CRITICAL GOTCHAS:**

1. **Very expensive:** 3N+1 API calls (e.g., 13 calls for 4 models)
   - **Fix:** Use for high-value queries only

2. **Slow:** Three sequential stages (15-30 seconds total)
   - **Fix:** Not suitable for real-time applications

3. **Not actually "agents":** Just orchestrated API calls
   - **Fix:** Don't expect agent-like lifecycle management

---

## Tool Coordination

### Tool Permission Inheritance

```pseudocode
class Agent:
  tools = []
  permissions = {}

  function spawnChild(config):
    child = new Agent({
      # Inherit tools
      tools: this.tools,

      # Create child permission scope
      permissions: this.permissions.createChildScope()
    })

    return child

class PermissionScope:
  function createChildScope():
    childScope = new PermissionScope()

    # Child inherits parent restrictions
    childScope.allowedTools = this.allowedTools
    childScope.deniedTools = this.deniedTools

    # Child CANNOT escalate permissions
    childScope.canEscalate = false

    return childScope
```

**Four-layer permission check:**

```pseudocode
function checkToolPermission(toolName):
  # 1. Allowlist check (fail-closed)
  if toolName not in session.allowedTools:
    return DENY

  # 2. SafeInternal annotation (highest precedence)
  if tool.safeInternal == true:
    return ALLOW

  # 3. Tool-specific policy
  policy = database.getPolicy(toolName)
  if policy == "allow":
    return ALLOW
  if policy == "deny":
    return DENY
  if policy == "ask":
    return ASK_USER

  # 4. Permission override mode
  if session.permissionMode == "yolo":
    return ALLOW
  if session.permissionMode == "read-only":
    return DENY if tool.modifiesState else ALLOW

  # Default: ask
  return ASK_USER
```

---

### Shared Resource Locking

```pseudocode
class ResourceLock:
  locked = Set()
  waiting = Map()  # resource -> [waiters]

  async function acquire(resource, timeout):
    if resource in locked:
      # Add to waiting queue
      promise = new Promise()
      if resource not in waiting:
        waiting[resource] = []
      waiting[resource].append(promise)

      # Wait with timeout
      result = await Promise.race([
        promise,
        sleep(timeout).then(() => throw TimeoutError())
      ])

      return result

    # Lock is available
    locked.add(resource)
    return true

  function release(resource):
    locked.remove(resource)

    # Wake up next waiter
    if resource in waiting and waiting[resource].length > 0:
      waiter = waiting[resource].shift()
      locked.add(resource)
      waiter.resolve(true)

# Usage in tool
class DatabaseMigrationTool:
  async function execute(args):
    await resourceLock.acquire("database", timeout=30000)
    try:
      return await runMigration(args)
    finally:
      resourceLock.release("database")
```

---

### Rate Limiting Across Agents

```pseudocode
class RateLimiter:
  tokens = maxTokens
  maxTokens = 100
  refillRate = 10  # tokens per second
  lastRefill = now()

  async function acquire(cost=1):
    while tokens < cost:
      # Calculate tokens to refill
      elapsed = now() - lastRefill
      tokensToAdd = elapsed * refillRate
      tokens = min(maxTokens, tokens + tokensToAdd)
      lastRefill = now()

      # Still not enough? Wait
      if tokens < cost:
        await sleep(100)

    # Consume tokens
    tokens -= cost
    return true

# Usage
class APITool:
  async function execute(args):
    await rateLimiter.acquire(cost=1)
    return await callExternalAPI(args)

# Multiple agents share the same rateLimiter instance
# Automatically coordinates API calls across all agents
```

---

### Tool Result Caching

```pseudocode
class CachedTool:
  cache = Map()
  maxCacheSize = 1000

  function getCacheKey(args):
    return hash(JSON.stringify(args))

  async function execute(args):
    key = getCacheKey(args)

    # Check cache
    if key in cache:
      emit("cache:hit", { tool: this.name, key: key })
      return cache[key]

    # Execute and cache
    result = await this.executeImpl(args)

    # Evict if cache full (LRU)
    if cache.size >= maxCacheSize:
      oldestKey = getOldestKey(cache)
      cache.delete(oldestKey)

    cache[key] = result
    emit("cache:miss", { tool: this.name, key: key })

    return result

  function invalidate(pattern):
    # Invalidate cache entries matching pattern
    for key in cache.keys():
      if matches(key, pattern):
        cache.delete(key)
```

**When to use caching:**
- ✅ Read-only tools (file read, grep, API fetch)
- ✅ Expensive operations (LLM calls, complex computations)
- ✅ Idempotent operations (same input → same output)
- ❌ Write operations (file write, database mutations)
- ❌ Time-sensitive operations (current time, random values)

---

## Lifecycle Management

### Cascading Stop (CRITICAL PATTERN)

**🚨 Problem:** Parent stops, children keep running (orphaned agents)

**✅ Solution:** Always stop children before stopping self

```pseudocode
class Agent:
  async function stop():
    # 1. Get all child agents
    children = session.getChildAgents(this.id)

    # 2. Stop all children FIRST (parallel)
    await Promise.all(children.map(child => child.stop()))

    # 3. Then stop self
    transitionTo("stopped")

    # Cancel ongoing work
    abortController.abort()

    # Flush events
    await eventStore.flush()

    # Clean up listeners
    removeAllListeners()

    # Emit final event
    emit("agent:stopped", { agentId: this.id })
```

**Why this matters:**
- Prevents resource leaks (orphaned agents burning LLM credits)
- Ensures clean shutdown
- Maintains referential integrity (no dangling references)

---

### Pause/Resume (If Your System Supports It)

**⚠️ Warning:** Many systems throw "not implemented" - check first!

```pseudocode
class Agent:
  pausedState = null

  function pause():
    if state == "stopped":
      throw Error("Cannot pause stopped agent")

    # Cancel current work
    abortController.abort()

    # Save state
    pausedState = {
      messages: this.messages,
      context: this.context,
      toolResults: this.toolResults,
      timestamp: now()
    }

    transitionTo("paused")
    emit("agent:paused", { agentId: this.id })

  async function resume():
    if state != "paused":
      throw Error("Can only resume paused agent")

    # Restore state
    this.messages = pausedState.messages
    this.context = pausedState.context
    this.toolResults = pausedState.toolResults

    # Create new abort controller
    abortController = new AbortController()

    transitionTo("thinking")
    emit("agent:resumed", { agentId: this.id })

    # Continue execution
    await this.continueExecution()
```

**If pause/resume NOT implemented:**

```pseudocode
# Manual checkpoint/restore
class Agent:
  async function saveCheckpoint():
    checkpoint = {
      agentId: this.id,
      state: this.state,
      messages: this.messages,
      context: this.context,
      toolResults: this.toolResults,
      timestamp: now()
    }

    checkpointId = await storage.save(checkpoint)
    return checkpointId

  async function restoreFromCheckpoint(checkpointId):
    checkpoint = await storage.load(checkpointId)

    this.state = checkpoint.state
    this.messages = checkpoint.messages
    this.context = checkpoint.context
    this.toolResults = checkpoint.toolResults

    if state == "thinking" or state == "tool_execution":
      await this.continueExecution()

# Usage
# Before long operation
checkpointId = await agent.saveCheckpoint()

# If interrupted
await agent.stop()

# Resume later
newAgent = session.spawnAgent(config)
await newAgent.restoreFromCheckpoint(checkpointId)
```

---

### Cost Aggregation

```pseudocode
class Agent:
  ownCost = 0

  function recordLLMCall(call):
    ownCost += call.inputTokens * call.inputPrice
    ownCost += call.outputTokens * call.outputPrice

    emit("cost:incurred", {
      agentId: this.id,
      cost: call.totalCost,
      cumulativeCost: ownCost
    })

  function getTotalCost():
    # Own cost
    total = ownCost

    # Aggregate children costs
    children = session.getAllAgents().filter(a =>
      a.id.startsWith(this.id + ".")
    )

    for child in children:
      total += child.getTotalCost()

    return total

  function getCostBreakdown():
    breakdown = {
      self: ownCost,
      children: {},
      total: 0
    }

    children = session.getDirectChildren(this.id)
    for child in children:
      breakdown.children[child.id] = child.getTotalCost()

    breakdown.total = getTotalCost()
    return breakdown
```

**Visualization:**

```
session (total: $2.50)
  ├─ self: $0.50
  ├─ session.1 (total: $1.20)
  │   ├─ self: $0.20
  │   ├─ session.1.1: $0.40
  │   ├─ session.1.2: $0.35
  │   └─ session.1.3: $0.25
  └─ session.2 (total: $0.80)
      ├─ self: $0.30
      └─ session.2.1: $0.50
```

---

## State Management

### Event-Sourcing Implementation

```pseudocode
class EventStore:
  events = []

  function append(event):
    event.id = generateEventId()
    event.timestamp = now()
    events.append(event)

    # Persist to storage
    storage.append(event)

    # Notify subscribers
    notifySubscribers(event)

  function getEventsForAgent(agentId):
    return events.filter(e => e.agentId == agentId)

  function getEventsForThread(threadId):
    return events.filter(e => e.threadId == threadId)

  function replayToState(agentId, timestamp):
    relevantEvents = events.filter(e =>
      e.agentId == agentId && e.timestamp <= timestamp
    )

    state = {}
    for event in relevantEvents:
      state = applyEvent(state, event)

    return state

# Event types
EVENT_TYPES = [
  "agent:spawned",
  "agent:started",
  "agent:state_changed",
  "tool:executed",
  "tool:result",
  "agent:completed",
  "agent:stopped",
  "agent:error"
]
```

**Benefits of event-sourcing:**
- ✅ Complete audit trail
- ✅ Replay for debugging
- ✅ Multiple views of same data
- ✅ Time-travel debugging
- ✅ Resume from any point

---

### Checkpointing Strategy

```pseudocode
class CheckpointManager:
  function shouldCheckpoint(agent):
    # Checkpoint after significant events
    return (
      agent.completedTools > 10 ||
      agent.cost > 1.00 ||
      timeSinceLastCheckpoint > 300000  # 5 minutes
    )

  async function saveCheckpoint(agent):
    checkpoint = {
      id: generateCheckpointId(),
      agentId: agent.id,
      state: agent.state,
      messages: agent.messages,
      context: agent.context,
      toolResults: agent.toolResults,
      cost: agent.getTotalCost(),
      timestamp: now()
    }

    await storage.saveCheckpoint(checkpoint)
    emit("checkpoint:saved", checkpoint.id)

    return checkpoint.id

  async function listCheckpoints(agentId):
    return storage.getCheckpoints(agentId)
      .sort((a, b) => b.timestamp - a.timestamp)

  async function restoreFromCheckpoint(checkpointId):
    checkpoint = await storage.loadCheckpoint(checkpointId)

    # Recreate agent
    agent = new Agent(checkpoint.agentId)
    agent.state = checkpoint.state
    agent.messages = checkpoint.messages
    agent.context = checkpoint.context
    agent.toolResults = checkpoint.toolResults

    return agent

# Usage in pipeline
async function robustPipeline(stages):
  for stage in stages:
    # Try to restore
    checkpoint = await checkpointManager.listCheckpoints(stage.name)[0]
    if checkpoint:
      agent = await checkpointManager.restoreFromCheckpoint(checkpoint.id)
      continue

    # Execute stage
    agent = spawnAgent(stage)
    result = await agent.execute(stage)

    # Checkpoint
    await checkpointManager.saveCheckpoint(agent)

  return result
```

---

## Defensive Patterns & Workarounds

### Orphaned Children Detection

```pseudocode
class OrphanDetector:
  function detectOrphans():
    orphans = []
    allAgents = session.getAllAgents()

    for agent in allAgents:
      if agent.parentId:
        parent = session.getAgent(agent.parentId)
        if not parent or parent.state == "stopped":
          orphans.append(agent)

    return orphans

  async function cleanupOrphans():
    orphans = detectOrphans()

    for orphan in orphans:
      log("Stopping orphaned agent: " + orphan.id)
      await orphan.stop()

    return orphans.length

# Run periodically
setInterval(async () => {
  count = await orphanDetector.cleanupOrphans()
  if count > 0:
    log("Cleaned up " + count + " orphaned agents")
}, 60000)  # Every minute
```

---

### Session vs Project Scope Workaround

**🚨 Problem:** Tasks are session-scoped, agents can't see each other's tasks

**✅ Solution:** Project-level task store

```pseudocode
class ProjectTaskStore:
  tasks = {}  # Shared across sessions
  projectId = null

  function createTask(task):
    task.projectId = this.projectId
    task.sessionId = getCurrentSession().id
    tasks[task.id] = task

    emit("task:created", task)
    return task

  function getAvailableTasks():
    return Object.values(tasks)
      .filter(t => t.projectId == this.projectId)
      .filter(t => t.status == "pending")

  function getTasksForSession(sessionId):
    return Object.values(tasks)
      .filter(t => t.sessionId == sessionId)

  function claimTask(taskId, agentId):
    task = tasks[taskId]
    if task.status != "pending":
      throw Error("Task not available")

    task.status = "in_progress"
    task.assignedTo = agentId
    task.claimedAt = now()

    emit("task:claimed", task)
    return task

# Usage: Work-stealing pattern
async function workerAgent():
  while true:
    # Any agent can claim any pending task
    availableTasks = projectTaskStore.getAvailableTasks()
    if availableTasks.length == 0:
      await sleep(1000)
      continue

    task = availableTasks[0]
    try:
      projectTaskStore.claimTask(task.id, this.id)
      result = await this.execute(task)
      projectTaskStore.completeTask(task.id, result)
    catch error:
      projectTaskStore.failTask(task.id, error)
```

---

### No Coordination Primitives Workaround

**🚨 Problem:** No built-in locks, semaphores, barriers

**✅ Solution:** Implement in-memory coordination

```pseudocode
class CoordinationManager:
  locks = {}
  semaphores = {}
  barriers = {}

  # Locks
  async function acquireLock(name, timeout):
    start = now()
    while name in locks:
      if now() - start > timeout:
        throw TimeoutError()
      await sleep(50)
    locks[name] = true

  function releaseLock(name):
    delete locks[name]

  # Semaphores
  function initSemaphore(name, maxCount):
    semaphores[name] = { current: 0, max: maxCount }

  async function acquireSemaphore(name, timeout):
    sem = semaphores[name]
    start = now()

    while sem.current >= sem.max:
      if now() - start > timeout:
        throw TimeoutError()
      await sleep(50)

    sem.current += 1

  function releaseSemaphore(name):
    sem = semaphores[name]
    sem.current = max(0, sem.current - 1)

  # Barriers
  function initBarrier(name, expectedCount):
    barriers[name] = {
      waiting: [],
      expected: expectedCount
    }

  async function waitAtBarrier(name):
    barrier = barriers[name]

    promise = new Promise()
    barrier.waiting.append(promise)

    # All arrived?
    if barrier.waiting.length >= barrier.expected:
      # Release all
      for waiter in barrier.waiting:
        waiter.resolve()
      barrier.waiting = []

    await promise

# Usage examples

# Lock
await coordination.acquireLock("database")
try:
  await runMigration()
finally:
  coordination.releaseLock("database")

# Semaphore (limit concurrent API calls)
coordination.initSemaphore("api-calls", maxCount=5)
await coordination.acquireSemaphore("api-calls")
try:
  await callAPI()
finally:
  coordination.releaseSemaphore("api-calls")

# Barrier (synchronization point)
coordination.initBarrier("stage1-complete", expectedCount=4)

# 4 agents do work...
await agent1.doWork()
await coordination.waitAtBarrier("stage1-complete")

# All 4 agents wait here until all arrive
# Then all proceed together
```

---

### In-Process Scalability Limitation

**🚨 Problem:** All agents in same process (no true parallelism)

**✅ Solution:** Use process/thread pools for CPU-bound work

```pseudocode
# Pattern A: Process Pool (Python)
from multiprocessing import Pool

def process_item(item):
  # Each item processed in separate process
  agent = create_agent()
  result = agent.execute(item)
  agent.stop()
  return result

pool = Pool(processes=4)
results = pool.map(process_item, items)
pool.close()

# Pattern B: Worker Threads (JavaScript)
const { Worker } = require('worker_threads');

function spawnWorker(task) {
  return new Promise((resolve, reject) => {
    const worker = new Worker('./agent-worker.js');
    worker.postMessage(task);
    worker.on('message', resolve);
    worker.on('error', reject);
  });
}

const results = await Promise.all(
  tasks.map(task => spawnWorker(task))
);

# Pattern C: Separate Processes (Go)
func spawnWorkerProcess(task Task) Result {
  cmd := exec.Command("./agent-worker", task.ID)
  output, err := cmd.Output()
  if err != nil {
    return Result{Error: err}
  }
  return parseResult(output)
}

var wg sync.WaitGroup
results := make([]Result, len(tasks))

for i, task := range tasks {
  wg.Add(1)
  go func(idx int, t Task) {
    defer wg.Done()
    results[idx] = spawnWorkerProcess(t)
  }(i, task)
}

wg.Wait()
```

---

## Complete Example: Code Review System

Let's put it all together with a real-world example:

```pseudocode
class CodeReviewOrchestrator:

  async function reviewPullRequest(prNumber):
    # 1. Discovery: Get PR metadata
    pr = await github.getPR(prNumber)
    files = pr.files

    # 2. Check if we can parallelize
    if files.length > 50:
      # Too many files - use batching
      return await this.batchedReview(files)

    # 3. Spawn specialist reviewers (fan-out)
    reviewers = [
      {
        persona: "security",
        focus: "SQL injection, XSS, auth bypass, secrets",
        model: "smart"  # Security is critical
      },
      {
        persona: "performance",
        focus: "N+1 queries, caching, indexing, memory leaks",
        model: "fast"  # Performance checks can be fast
      },
      {
        persona: "style",
        focus: "naming, formatting, complexity, maintainability",
        model: "fast"  # Style is straightforward
      },
      {
        persona: "tests",
        focus: "coverage, edge cases, mocking, assertions",
        model: "smart"  # Testing needs careful analysis
      }
    ]

    agents = []
    for reviewer in reviewers:
      agent = spawnAgent({
        persona: reviewer.persona,
        model: reviewer.model,
        tools: ["read_file", "grep", "ast_search"]
      })
      agents.append(agent)

      # Set up monitoring
      this.setupAgentMonitoring(agent, reviewer.persona)

    # 4. Execute reviews in parallel with timeout
    reviewTasks = []
    for i, agent in enumerate(agents):
      reviewTasks.append(
        this.executeReviewWithTimeout(
          agent,
          reviewers[i],
          files,
          timeout=120000  # 2 minutes per reviewer
        )
      )

    # 5. Gather results (continue on error)
    results = await Promise.allSettled(reviewTasks)

    # 6. Build report (even with partial failures)
    report = {
      pr: prNumber,
      files: files,
      issues: [],
      costs: {},
      errors: [],
      timestamp: now()
    }

    for i, result in enumerate(results):
      reviewer = reviewers[i]
      agent = agents[i]

      if result.status == "fulfilled":
        # Success
        report.issues.push(...result.value.issues)
      else:
        # Failure
        report.errors.push({
          reviewer: reviewer.persona,
          error: result.reason
        })

      # Track cost regardless of success/failure
      report.costs[reviewer.persona] = agent.getTotalCost()

    # 7. Clean up (cascading stop)
    await Promise.all(agents.map(a => a.stop()))

    # 8. Aggregate costs
    report.totalCost = Object.values(report.costs)
      .reduce((sum, cost) => sum + cost, 0)

    return report

  async function executeReviewWithTimeout(agent, reviewer, files, timeout):
    try:
      return await Promise.race([
        agent.execute({
          prompt: `Review these files: ${files.join(', ')}

          Focus on: ${reviewer.focus}

          Return JSON:
          {
            "issues": [
              {
                "file": "path/to/file",
                "line": 42,
                "severity": "critical" | "high" | "medium" | "low",
                "category": "security" | "performance" | "style" | "tests",
                "description": "What's wrong",
                "suggestion": "How to fix"
              }
            ]
          }`,
          context: { files: files, focus: reviewer.focus }
        }),
        sleep(timeout).then(() => {
          throw TimeoutError("Review took too long")
        })
      ])
    catch error:
      throw error

  async function batchedReview(files):
    # Split files into batches
    BATCH_SIZE = 10
    batches = chunk(files, BATCH_SIZE)

    allIssues = []
    allCosts = {}

    for batch in batches:
      log("Reviewing batch: " + batch.join(", "))

      # Review batch (reuse main review logic)
      batchReport = await this.reviewPullRequest_internal(batch)

      allIssues.push(...batchReport.issues)

      # Aggregate costs
      for reviewer, cost in batchReport.costs:
        if reviewer not in allCosts:
          allCosts[reviewer] = 0
        allCosts[reviewer] += cost

    return {
      files: files,
      issues: allIssues,
      costs: allCosts,
      totalCost: Object.values(allCosts).reduce((a, b) => a + b, 0)
    }

  function setupAgentMonitoring(agent, reviewerType):
    agent.on("state:changed", event => {
      log(`[${reviewerType}] State: ${event.state}`)
    })

    agent.on("tool:executing", event => {
      log(`[${reviewerType}] Tool: ${event.tool}`)
    })

    agent.on("error", error => {
      log(`[${reviewerType}] ERROR: ${error}`)
    })

# Usage
orchestrator = new CodeReviewOrchestrator()
report = await orchestrator.reviewPullRequest(1234)

console.log(`Found ${report.issues.length} issues`)
console.log(`Total cost: $${report.totalCost.toFixed(2)}`)

if report.errors.length > 0:
  console.log(`${report.errors.length} reviewers failed`)
```

**This example demonstrates:**
- ✅ Fan-out/fan-in pattern
- ✅ Heterogeneous models (smart for security/tests, fast for style/perf)
- ✅ Timeout handling
- ✅ Graceful degradation (partial failures)
- ✅ Cost tracking
- ✅ Batching for large inputs
- ✅ Cascading cleanup
- ✅ Event monitoring

---

## Execution Checklist

When you use this skill, follow this workflow:

**Phase 1: Discovery (MANDATORY)**
- [ ] Ask all 6 discovery questions
- [ ] Understand constraints (language, framework, scale)
- [ ] Identify primary coordination pattern needed

**Phase 2: Architecture Guidance**
- [ ] Present relevant foundational patterns
- [ ] Explain communication mechanism for their stack
- [ ] Show spawning pattern best suited to use case

**Phase 3: Coordination Implementation**
- [ ] Provide pseudocode for chosen pattern
- [ ] Include gotchas and defensive workarounds
- [ ] Show cost optimization strategies

**Phase 4: Tool Coordination**
- [ ] Design tool permission inheritance
- [ ] Add resource locking if needed
- [ ] Implement rate limiting if external APIs

**Phase 5: Lifecycle & State**
- [ ] Implement cascading stop (CRITICAL!)
- [ ] Add checkpointing if long-running
- [ ] Set up cost aggregation

**Phase 6: Production Hardening**
- [ ] Add orphan detection
- [ ] Implement coordination primitives if needed
- [ ] Add monitoring/observability

**Phase 7: Complete Example**
- [ ] Provide end-to-end example specific to their use case
- [ ] Show all patterns working together
- [ ] Include error handling and cleanup

---

## Remember

**Language-agnostic:** Focus on patterns, not specific syntax
**Teach what works:** Production-ready patterns with defensive warnings
**Comprehensive:** Cover all major coordination patterns
**Tool-aware:** Tools are integral to agent architecture
**Defensive:** Warn about known gaps and provide workarounds

**Testing is up to them:** Don't prescribe testing strategies unless asked

---

## Common Pitfalls to Avoid

1. ❌ **Don't implement cascading stop** → Orphaned agents
2. ❌ **Don't set timeouts** → Agents hang forever
3. ❌ **Don't limit concurrent agents** → Resource exhaustion
4. ❌ **Don't track costs** → Budget surprises
5. ❌ **Don't handle partial failures** → One agent fails, all fail
6. ❌ **Don't checkpoint long pipelines** → Can't resume on failure
7. ❌ **Don't coordinate tool access** → Race conditions
8. ❌ **Don't use cheap models for map phase** → Waste money
9. ❌ **Don't batch large inputs** → Spawn 1000 agents at once
10. ❌ **Don't emit progress events** → No visibility into what's happening

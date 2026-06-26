# ABOUTME: Fish wrapper to run Claude Code against Fireworks AI's Anthropic-compatible endpoint.
# ABOUTME: Maps Claude Code's Opus/Sonnet/Haiku/subagent tiers to Fireworks models; override the main model with -m/--model.
function claude-fireworks --description 'Run Claude Code against Fireworks AI (override main model with -m/--model)'
    # Consume our own -m/--model; leave all other flags for claude (-i = ignore-unknown).
    argparse -i 'm/model=' -- $argv
    or return

    # Default main/interactive model when -m/--model is not supplied.
    set -l model "accounts/fireworks/routers/glm-latest[1m]"
    set -q _flag_model; and set model $_flag_model

    # Load the Fireworks auth token from a locked secrets file if it isn't
    # already exported in the environment.
    set -q ANTHROPIC_AUTH_TOKEN
    or source $__fish_config_dir/.secrets/fireworks.env

    # Map Claude Code's model tiers to Fireworks models, mirroring Fireworks'
    # FireConnect recommendations (docs.fireworks.ai/ecosystem/fireconnect/claude-code).
    env ANTHROPIC_BASE_URL=https://api.fireworks.ai/inference \
        ANTHROPIC_AUTH_TOKEN=$ANTHROPIC_AUTH_TOKEN \
        ANTHROPIC_DEFAULT_OPUS_MODEL="accounts/fireworks/routers/glm-latest[1m]" \
        ANTHROPIC_DEFAULT_SONNET_MODEL=accounts/fireworks/models/glm-5p1 \
        ANTHROPIC_DEFAULT_HAIKU_MODEL=accounts/fireworks/models/minimax-m2p5 \
        CLAUDE_CODE_SUBAGENT_MODEL=accounts/fireworks/models/minimax-m2p5 \
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
        claude --model $model $argv
end

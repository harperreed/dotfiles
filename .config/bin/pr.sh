#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
# PROMPT_DIR will be set in setup_prompts() if not provided as env var

# Parse command line arguments
CLEANUP_MODE=false
while getopts ":c" opt; do
  case ${opt} in
    c )
      CLEANUP_MODE=true
      ;;
    \? )
      echo "Usage: $0 [-c]"
      echo "  -c  Cleanup mode: removes PROMPT_DIR config from shell files and deletes prompt files"
      echo
      echo "Examples:"
      echo "  $0        # Regular mode - create a PR"
      echo "  $0 -c     # Cleanup mode - remove configurations and prompt files"
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Default prompt templates
DEFAULT_TITLE_PROMPT='Write a concise, informative pull request title:

* It should be a very short summary in imperative mood
* Explain the "why" behind changes more so than the changes
* Keep the title under 50 characters
* If there are no changes, or the input is blank - then return a blank string

Think carefully before you write your title.

What you write will be passed to create the title of a github pull request'

DEFAULT_BODY_PROMPT='Write a clear, informative pull request message in markdown:

* Remember to mention the files that were changed, and what was changed
* Start with a summary
* Explain the "why" behind changes
* Include a bulleted list to outline all of the changes
* If there are changes that resolve specified issues add the issues to a list of closed issues
* If there are no changes, or the input is blank - then return a blank string

Think carefully before you write your pull request body.

What you write will be passed to create a github pull request'

# Logging function
log() {
  local level=$1
  local message=$2
  case $level in
    "INFO") echo -e "${GREEN}[INFO]${NC} $message" ;;
    "WARN") echo -e "${YELLOW}[WARN]${NC} $message" ;;
    "ERROR") echo -e "${RED}[ERROR]${NC} $message" ;;
  esac
}

# Function to display a spinning animation
spin_animation() {
  spinner=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  while true; do
    for i in "${spinner[@]}"; do
      tput civis # Hide the cursor
      tput el1 # Clear the line from the cursor to the beginning
      printf "\r${YELLOW}%s${NC} %s..." "$i" "$1"
      sleep 0.1
      tput cub $(( ${#1} + 5 )) # Move the cursor back
    done
  done
}

# Function to handle interrupts
handle_interrupt() {
  echo -e "\n${RED}Script interrupted. Cleaning up...${NC}"
  tput cnorm # Show the cursor
  exit 1
}

# Function to clean up prompt configuration and files
cleanup_prompt_config() {
  local found_config=false
  local original_prompt_dir=""
  
  # Find PROMPT_DIR in config files
  echo -e "${YELLOW}Warning: This will remove PROMPT_DIR configuration${NC}"
  echo -e "${YELLOW}and delete all prompt template files.${NC}"
  read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
  echo
  
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log "INFO" "Cleanup operation cancelled."
    exit 0
  fi
  
  # Check for PROMPT_DIR in .env file
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local env_file="${script_dir}/.env"
  
  if [ -f "$env_file" ] && grep -q "^PROMPT_DIR=" "$env_file"; then
    # Extract the PROMPT_DIR value from the .env file
    local env_prompt_dir=$(grep "^PROMPT_DIR=" "$env_file" | sed -E 's/PROMPT_DIR="(.*)"/\1/')
    
    # Handle tilde expansion for home directory
    if [[ "$env_prompt_dir" == "~/"* ]]; then
      env_prompt_dir="${env_prompt_dir/#\~/$HOME}"
    fi
    
    if [ -n "$env_prompt_dir" ] && [ -d "$env_prompt_dir" ]; then
      log "INFO" "Found configured PROMPT_DIR in .env file: $env_prompt_dir"
      original_prompt_dir="$env_prompt_dir"
      found_config=true
    fi
  fi
  
  # If we have a defined PROMPT_DIR from env, prioritize that
  if [[ -n "${PROMPT_DIR+x}" ]]; then
    log "INFO" "Using environment PROMPT_DIR: $PROMPT_DIR"
    original_prompt_dir="$PROMPT_DIR"
  fi
  
  # If we still don't have a prompt dir, check default location
  if [ -z "$original_prompt_dir" ]; then
    if [ -d "./prompts" ]; then
      log "INFO" "Using default prompt directory: ./prompts"
      original_prompt_dir="./prompts"
    fi
  fi
  
  # Delete prompt files if we found a directory
  if [ -n "$original_prompt_dir" ] && [ -d "$original_prompt_dir" ]; then
    log "INFO" "Deleting prompt files in $original_prompt_dir..."
    if [ -f "$original_prompt_dir/pr-title-prompt.txt" ]; then
      rm "$original_prompt_dir/pr-title-prompt.txt"
      log "INFO" "Deleted $original_prompt_dir/pr-title-prompt.txt"
    fi
    
    if [ -f "$original_prompt_dir/pr-body-prompt.txt" ]; then
      rm "$original_prompt_dir/pr-body-prompt.txt"
      log "INFO" "Deleted $original_prompt_dir/pr-body-prompt.txt"
    fi
    
    # Try to remove the directory if it's empty
    if [ -z "$(ls -A "$original_prompt_dir")" ]; then
      rmdir "$original_prompt_dir"
      log "INFO" "Removed empty directory $original_prompt_dir"
    fi
  else
    log "INFO" "No prompt directory found. Nothing to delete."
  fi
  
  # Remove PROMPT_DIR from .env file if it exists
  if [ -f "$env_file" ] && grep -q "^PROMPT_DIR=" "$env_file"; then
    log "INFO" "Found PROMPT_DIR in .env file. Removing..."
    # Create a backup
    cp "$env_file" "${env_file}.bak"
    # Remove the PROMPT_DIR line
    grep -v "^PROMPT_DIR=" "$env_file" > "${env_file}.tmp" && mv "${env_file}.tmp" "$env_file"
    log "INFO" "Removed PROMPT_DIR from .env file. Backup saved as ${env_file}.bak"
    found_config=true
  fi
  
  if [ "$found_config" = false ]; then
    log "INFO" "No PROMPT_DIR configuration found."
  fi
  
  log "INFO" "Cleanup completed successfully."
}

# Function to handle initial setup of prompt templates
setup_prompts() {
  # Function to save PROMPT_DIR to .env file
  save_prompt_dir_to_config() {
    # Default location for .env file in the same directory as the script
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local env_file="${script_dir}/.env"
    
    # Create or update .env file
    if [ -f "$env_file" ]; then
      # Check if PROMPT_DIR is already in the .env file
      if grep -q "^PROMPT_DIR=" "$env_file"; then
        # Update existing PROMPT_DIR
        sed -i.bak "s|^PROMPT_DIR=.*|PROMPT_DIR=\"$PROMPT_DIR\"|" "$env_file"
      else
        # Add new PROMPT_DIR
        echo "PROMPT_DIR=\"$PROMPT_DIR\"" >> "$env_file"
      fi
    else
      # Create new .env file
      echo "# LLM PR Helper Environment Variables" > "$env_file"
      echo "PROMPT_DIR=\"$PROMPT_DIR\"" >> "$env_file"
    fi
    log "INFO" "Saved PROMPT_DIR to $env_file"
  }

  # Try loading from .env file
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local env_file="${script_dir}/.env"
  local config_saved=false
  
  # If PROMPT_DIR not set, try to load it from .env
  if [[ -z "${PROMPT_DIR+x}" ]]; then
    if [ -f "$env_file" ] && grep -q "^PROMPT_DIR=" "$env_file"; then
      # Extract the PROMPT_DIR value
      PROMPT_DIR=$(grep "^PROMPT_DIR=" "$env_file" | sed -E 's/PROMPT_DIR="(.*)"/\1/')
      
      # Handle tilde expansion
      if [[ "$PROMPT_DIR" == "~/"* ]]; then
        PROMPT_DIR="${PROMPT_DIR/#\~/$HOME}"
      fi
      
      log "INFO" "Using saved PROMPT_DIR from .env file: $PROMPT_DIR"
      config_saved=true
    fi
    
    # If still not set, use default or prompt user
    if [[ -z "${PROMPT_DIR+x}" ]]; then
      # Check if the default location exists and has prompt files
      local default_dir="./prompts"
      if [ -d "$default_dir" ] && 
         ([ -f "$default_dir/pr-title-prompt.txt" ] || [ -f "$default_dir/pr-body-prompt.txt" ]); then
        PROMPT_DIR="$default_dir"
        log "INFO" "Using existing prompt directory: $PROMPT_DIR"
      else
        # Prompt user for directory
        log "INFO" "Setting up prompt templates for LLM PR Helper."
        read -p "Where would you like to store prompt templates? (default: ./prompts): " user_prompt_dir
        if [ -n "$user_prompt_dir" ]; then
          # Handle tilde expansion for home directory
          if [[ "$user_prompt_dir" == "~/"* ]]; then
            PROMPT_DIR="${user_prompt_dir/#\~/$HOME}"
          else
            PROMPT_DIR="$user_prompt_dir"
          fi
        else
          PROMPT_DIR="./prompts"
        fi
        log "INFO" "Prompt templates will be stored in: $PROMPT_DIR"
        
        # Automatically save this choice
        save_prompt_dir_to_config
        config_saved=true
      fi
    fi
  fi

  # Create the directory if it doesn't exist
  if [ ! -d "$PROMPT_DIR" ]; then
    log "INFO" "Creating directory: $PROMPT_DIR"
    mkdir -p "$PROMPT_DIR"
  fi

  # Save default prompts if missing
  # Check for title prompt
  if [ ! -f "$PROMPT_DIR/pr-title-prompt.txt" ]; then
    log "INFO" "Creating default PR title prompt template."
    echo "$DEFAULT_TITLE_PROMPT" > "$PROMPT_DIR/pr-title-prompt.txt"
    log "INFO" "Saved default PR title prompt to $PROMPT_DIR/pr-title-prompt.txt"
  fi

  # Check for body prompt
  if [ ! -f "$PROMPT_DIR/pr-body-prompt.txt" ]; then
    log "INFO" "Creating default PR body prompt template."
    echo "$DEFAULT_BODY_PROMPT" > "$PROMPT_DIR/pr-body-prompt.txt"
    log "INFO" "Saved default PR body prompt to $PROMPT_DIR/pr-body-prompt.txt"
  fi
  
  log "INFO" "You can edit these prompt files anytime to customize the prompts."
}

# Git-related functions
get_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

get_default_base_branch() {
  local current_branch=$(get_current_branch)
  
  # Get the repository's default branch (main, master, etc.)
  local default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  
  # Check if the current branch was directly branched from another branch
  local branch_point=$(git reflog show --no-abbrev $current_branch | grep "from branch" | head -n 1 | sed -E 's/.*from branch ([^:]+).*/\1/')
  
  # If we found a direct parent branch that's not the default branch, use it
  if [[ -n "$branch_point" && "$branch_point" != "$default_branch" ]]; then
    # Verify the branch exists remotely
    if git ls-remote --exit-code --heads origin $branch_point > /dev/null 2>&1; then
      echo $branch_point
      return
    fi
  fi
  
  # If we're here, either we couldn't find a parent branch or it doesn't exist remotely
  # Fall back to the default branch
  echo $default_branch
}

check_unpushed_commits() {
  local current_branch=$(get_current_branch)
  local remote_branch="origin/$current_branch"

  if ! git rev-parse --verify $remote_branch >/dev/null 2>&1; then
    log "WARN" "Remote branch $remote_branch does not exist."
    return 1
  fi

  local unpushed=$(git log $remote_branch..$current_branch --oneline)
  if [ -n "$unpushed" ]; then
    log "WARN" "Unpushed commits found:"
    echo "$unpushed"
    return 1
  fi
  return 0
}

generate_diff() {
  git diff $1..$2
}

# GitHub-related functions
get_github_remote() {
  git remote -v | grep -E '^[^[:space:]]+\s+(https?://github\.com/|git@github\.com:)' | awk '{print $1}' | uniq
}

get_repo_info() {
  gh repo view --json defaultBranchRef,nameWithOwner --jq '{ nameWithOwner: .nameWithOwner, defaultBranchRef: .defaultBranchRef.name }'
}

check_existing_pr() {
  gh pr list --repo "$1" --head "$2" --json number --jq '.[0].number'
}

# Main script execution
# Function to check if required dependencies are installed
check_dependencies() {
  # Check if git is installed
  if ! command -v git &> /dev/null; then
    log "ERROR" "Git is not installed or not in your PATH"
    echo -e "${YELLOW}Please install git before running this script:${NC}"
    echo -e "  https://git-scm.com/downloads"
    exit 1
  fi

  # Check if jq is installed (used for JSON parsing)
  if ! command -v jq &> /dev/null; then
    log "ERROR" "jq is not installed or not in your PATH"
    echo -e "${YELLOW}To install jq:${NC}"
    echo -e "  brew install jq     # macOS"
    echo -e "  sudo apt install jq # Debian/Ubuntu"
    exit 1
  fi

  # Check if llm is installed
  if ! command -v llm &> /dev/null; then
    log "ERROR" "The 'llm' command is not installed or not in your PATH"
    echo -e "${YELLOW}To install llm, run one of these commands:${NC}"
    echo -e "  pip install llm"
    echo -e "  brew install llm"
    echo -e "  pipx install llm"
    echo
    echo -e "${YELLOW}After installing, set up your API key:${NC}"
    echo -e "  llm keys set openai"
    exit 1
  fi
  
  # Check if gh (GitHub CLI) is installed - this is optional but we should warn
  if ! command -v gh &> /dev/null; then
    log "WARN" "The GitHub CLI (gh) is not installed. You won't be able to create PRs directly."
    log "INFO" "The script will still generate PR title and body text."
    log "INFO" "To install GitHub CLI, visit: https://github.com/cli/cli#installation"
  fi
}

main() {
  trap handle_interrupt SIGINT

  # If in cleanup mode, just clean up and exit
  if [ "$CLEANUP_MODE" = true ]; then
    cleanup_prompt_config
    exit 0
  fi

  # Check dependencies
  check_dependencies

  # Check and set up prompts if needed
  setup_prompts

  log "INFO" "Fetching git remotes..."
  if ! git remote -v > /dev/null 2>&1; then
    log "ERROR" "Are you sure this is a git repo? Are you sure you have git installed?"
    exit 1
  fi

  # Check for unpushed commits
  if ! check_unpushed_commits; then
    read -p "Do you want to push these commits before creating the PR? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
      log "INFO" "Pushing commits..."
      if ! git push; then
        log "ERROR" "Failed to push commits. Please resolve any issues and try again."
        exit 1
      fi
      log "INFO" "Commits pushed successfully."
    else
      log "WARN" "Proceeding without pushing commits. This may affect the PR creation process."
    fi
  fi

  # Set up GitHub-related variables
  GITHUB_REMOTE=$(get_github_remote)
  if [ -z $GITHUB_REMOTE ]; then
    log "WARN" "No GitHub remote found. Using 'origin' as default."
    GITHUB_REMOTE="origin"
    IS_GITHUB="false"
    BASE_BRANCH="HEAD"
  else
    IS_GITHUB="true"
    log "INFO" "GitHub remote found: $GITHUB_REMOTE"
    log "INFO" "Fetching repository information..."
    REPO_INFO=$(get_repo_info)
    if [ $? -ne 0 ]; then
      log "ERROR" "Failed to fetch repository information. Is the gh CLI tool installed and authenticated?"
      exit 1
    fi
    REPO_NAME=$(echo "$REPO_INFO" | jq -r '.nameWithOwner')
    DEFAULT_BRANCH=$(echo "$REPO_INFO" | jq -r '.defaultBranchRef')
    log "INFO" "Repository: $REPO_NAME, Default branch: $DEFAULT_BRANCH"

    # Determine the most likely base branch
    local suggested_base=$(get_default_base_branch)
    if [ "$suggested_base" != "$DEFAULT_BRANCH" ]; then
      log "INFO" "Detected likely parent branch: $suggested_base"
    fi
    
    # Prompt for base branch
    read -p "Enter the base branch (default: $suggested_base): " BASE_BRANCH
    BASE_BRANCH=${BASE_BRANCH:-$suggested_base}
    log "INFO" "Using base branch: $BASE_BRANCH"
  fi

  # Get the current branch name
  HEAD_BRANCH=$(get_current_branch)
  log "INFO" "Current branch: $HEAD_BRANCH"

  # Check for remote branch
  log "INFO" "Checking for remote branch..."
  if ! git ls-remote --exit-code --heads $GITHUB_REMOTE $HEAD_BRANCH > /dev/null 2>&1; then
    log "WARN" "No remote branch found for $HEAD_BRANCH"
    read -p "Would you like to push the current branch to remote? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      log "INFO" "Pushing branch $HEAD_BRANCH to $GITHUB_REMOTE..."
      if ! git push -u $GITHUB_REMOTE $HEAD_BRANCH; then
        log "ERROR" "Failed to push the branch. Please check your permissions and try again."
        exit 1
      fi
      log "INFO" "Branch pushed successfully."
    else
      log "WARN" "Cannot proceed without a remote branch. Exiting."
      exit 1
    fi
  else
    log "INFO" "Remote branch found for $HEAD_BRANCH"
  fi

  # Check for uncommitted changes
  UNCOMMITTED_CHANGES=$(git status --porcelain | wc -l)
  if [ $UNCOMMITTED_CHANGES -gt 0 ]; then
    log "WARN" "$UNCOMMITTED_CHANGES uncommitted changes"
  fi

  # Generate PR title and body
  log "INFO" "Generating PR title..."
  spin_animation "Generating PR Title" &
  spin_pid=$!
  DIFF=$(generate_diff "$GITHUB_REMOTE/$BASE_BRANCH" "$GITHUB_REMOTE/$HEAD_BRANCH")
  if [ -z "$DIFF" ]; then
    log "ERROR" "No diff found between $BASE_BRANCH and $HEAD_BRANCH"
    kill $spin_pid
    wait $spin_pid 2>/dev/null
    tput cnorm
    exit 1
  fi
  
  TITLE=$(echo "$DIFF" | llm -s "$(cat "$PROMPT_DIR/pr-title-prompt.txt")")
  kill $spin_pid
  wait $spin_pid 2>/dev/null
  tput cnorm
  echo

  log "INFO" "Generating PR body..."
  spin_animation "Generating PR Body" &
  spin_pid=$!
  BODY=$(echo "$DIFF" | llm -s "$(cat "$PROMPT_DIR/pr-body-prompt.txt")")
  kill $spin_pid
  wait $spin_pid 2>/dev/null
  tput cnorm
  echo

  # Prompt for draft PR
  read -p "Create as draft PR? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    TITLE="[DRAFT] $TITLE"
  fi

  # Create or update PR
  if [ "$IS_GITHUB" == "true" ]; then
    log "INFO" "Checking for existing PR..."
    EXISTING_PR=$(check_existing_pr "$REPO_NAME" "$HEAD_BRANCH")
    PR_URL=""
    
    if [ -n "$EXISTING_PR" ]; then
      log "INFO" "Updating the existing PR (#$EXISTING_PR) on ${REPO_NAME}."
      gh pr edit "$EXISTING_PR" --repo "$REPO_NAME" --title "$TITLE" --body "$BODY"
      PR_URL=$(gh pr view "$EXISTING_PR" --json url --jq .url)
    else
      log "INFO" "No existing PR found, creating a new one."
      # Capture the output which contains the URL
      PR_OUTPUT=$(gh pr create --repo "$REPO_NAME" --base "$BASE_BRANCH" --head "$HEAD_BRANCH" --title "$TITLE" --body "$BODY")
      PR_URL=$(echo "$PR_OUTPUT" | grep -o 'https://github.com/[^ ]*' | head -1)
    fi
    
    # Display condensed success message with PR link if we have a URL
    if [ -n "$PR_URL" ]; then
      echo -e "Pull Request - ${GREEN}$TITLE${NC} created\n${BLUE}$PR_URL${NC}"
    else
      # Fallback to displaying the generated content
      echo -e "${BLUE}=== Generated PR Message ===${NC}"
      echo -e "${BLUE}Title:${NC}\n${GREEN}$TITLE${NC}\n"
      echo -e "${BLUE}Body:${NC}\n${GREEN}$BODY${NC}"
      echo -e "${BLUE}=================================${NC}"
    fi
  else
    log "WARN" "Not GitHub, not creating the PR automatically."
    # Display the generated PR message for non-GitHub repos
    echo -e "${BLUE}=== Generated PR Message ===${NC}"
    echo -e "${BLUE}Title:${NC}\n${GREEN}$TITLE${NC}\n"
    echo -e "${BLUE}Body:${NC}\n${GREEN}$BODY${NC}"
    echo -e "${BLUE}=================================${NC}"
  fi

  log "INFO" "Script completed successfully."
}

main

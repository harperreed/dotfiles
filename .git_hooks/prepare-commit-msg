#!/bin/sh

# Exit if the `SKIP_LLM_GITHOOK` environment variable is set
if [ ! -z "$SKIP_LLM_GITHOOK" ]; then
  exit 0
fi

# ANSI color codes for styling the output
RED='\033[0;31m'    # Sets text to red
GREEN='\033[0;32m'  # Sets text to green
YELLOW='\033[0;33m' # Sets text to yellow
BLUE='\033[0;34m'   # Sets text to blue
NC='\033[0m'        # Resets the text color to default, no color


# Function to display a spinning animation during the LLM processing
spin_animation() {
  # Array of spinner characters for the animation
  spinner=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  # Infinite loop to keep the animation running
  while true; do
    for i in "${spinner[@]}"; do
      tput civis  # Hide the cursor to enhance the animation appearance
      tput el1    # Clear the line from the cursor to the beginning to display the spinner
      printf "\\r${YELLOW}%s${NC} Generating LLM commit message..." "$i"  # Print the spinner and message
      sleep 0.1   # Delay to control the speed of the animation
      tput cub 32 # Move the cursor back 32 columns to reset the spinner position
    done
  done
}

# Check if the commit is a merge commit based on the presence of a second argument
if [ -n "$2" ]; then
  exit 0  # Exit script if it's a merge commit, no custom message needed
fi

# Check if the `llm` command is installed
if ! command -v llm &> /dev/null; then
  echo "${RED}Error: 'llm' command is not installed. Please install it and try again.${NC}"
  exit 1
fi

# Start the spinning animation in the background
spin_animation &
spin_pid=$!  # Capture the process ID of the spinning animation

# Generate the commit message using `git diff` piped into `llm` command
# The LLM command takes a system prompt from a file as input
if ! commit_msg=$(git diff --cached | llm -s "$(cat ~/.config/prompts/commit-system-prompt.txt)" 2>&1); then
  # Stop the spinning animation by killing its process
  kill $spin_pid
  wait $spin_pid 2>/dev/null  # Wait for the process to terminate and suppress error messages

  # Finalizing output
  tput cnorm  # Show the cursor again
  printf "\\n"  # Move the cursor to the next line

  printf "${RED}Error: 'llm' command failed to generate the commit message:\\n${commit_msg}${NC}\\n\\nManually set the commit message"
  exit 1
fi

# Stop the spinning animation by killing its process
kill $spin_pid
wait $spin_pid 2>/dev/null  # Wait for the process to terminate and suppress error messages

# Finalizing output
tput cnorm  # Show the cursor again
echo  # Move the cursor to the next line

# Display the generated commit message with color-coded headings
echo "${BLUE}=== Generated Commit Message ===${NC}"
echo "${GREEN}$commit_msg${NC}"
echo "${BLUE}=================================${NC}"
echo

# Write the generated commit message to the specified file (usually the commit message file in .git)
echo "$commit_msg" > "$1"

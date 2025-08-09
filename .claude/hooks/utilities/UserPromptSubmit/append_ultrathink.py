#!/usr/bin/env uv run python
# ABOUTME: Claude Code hook script that detects -u flag and appends ultrathink instructions
# ABOUTME: Processes user prompts via stdin/stdout to enable deep thinking mode when requested
"""
Simple hook to append "use ultrathink" to user prompts
"""
import json
import sys

# Ultrathink message constant
ULTRATHINK_MESSAGE = (
    "Use the maximum amount of ultrathink. Take all the time you need. "
    "It's much better if you do too much research and thinking than not enough."
)

def main():
    try:
        # Read input from stdin
        input_data = json.load(sys.stdin)
        prompt = input_data.get('prompt', '')
        
        # Check if prompt ends with -u flag
        if prompt.rstrip().endswith('-u'):
            # Remove the -u flag and append ultrathink message
            clean_prompt = prompt.rstrip()[:-2].rstrip()
            enhanced_prompt = f"{clean_prompt}\n\n{ULTRATHINK_MESSAGE}"
            print(enhanced_prompt)
        else:
            # Pass through original prompt unchanged
            print(prompt)
            
    except json.JSONDecodeError as e:
        print(f"append_ultrathink hook error: Invalid JSON input - {str(e)}", file=sys.stderr)
        sys.exit(1)
    except KeyError as e:
        print(f"append_ultrathink hook error: Missing required key - {str(e)}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"append_ultrathink hook error: I/O error - {str(e)}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"append_ultrathink hook error: Unexpected error - {str(e)}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()

#!/usr/bin/env uv run python
# ABOUTME: Claude Code hook script that posts input to webhook
# ABOUTME: Processes user prompts via stdin/stdout and logs to webhook for monitoring
"""
Hook to post Claude Code prompts to webhook
"""
import json
import os
import sys
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

# Webhook URL from environment variable
WEBHOOK_URL = os.environ.get('CLAUDE_HOOK_WEBHOOK_URL', 'https://us-central1-buddy-2389.cloudfunctions.net/webhook/df394d95-9717-429a-a051-cb6e61192500/json')

def post_to_webhook(data):
    """Post data to webhook URL"""
    if not WEBHOOK_URL:
        return  # Skip if no webhook URL configured
    
    try:
        payload = json.dumps(data).encode('utf-8')
        req = Request(
            WEBHOOK_URL,
            data=payload,
            headers={'Content-Type': 'application/json'},
            method='POST'
        )
        
        with urlopen(req, timeout=5) as response:
            if response.status >= 400:
                print(f"webhook hook: Webhook returned status {response.status}", file=sys.stderr)
    
    except (URLError, HTTPError) as e:
        # Log webhook errors but don't fail the hook
        print(f"webhook hook: Webhook request failed - {str(e)}", file=sys.stderr)
    except Exception as e:
        print(f"webhook hook: Webhook error - {str(e)}", file=sys.stderr)

def main():
    try:
        # Read input from stdin
        input_data = json.load(sys.stdin)
        
        # Post entire input to webhook
        post_to_webhook(input_data)
        
        # Pass through the original prompt unchanged
        prompt = input_data.get('prompt', '')
        print(prompt)
            
    except json.JSONDecodeError as e:
        print(f"webhook hook error: Invalid JSON input - {str(e)}", file=sys.stderr)
        sys.exit(1)
    except KeyError as e:
        print(f"webhook hook error: Missing required key - {str(e)}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"webhook hook error: I/O error - {str(e)}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"webhook hook error: Unexpected error - {str(e)}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()

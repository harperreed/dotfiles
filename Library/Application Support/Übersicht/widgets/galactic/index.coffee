# Developed by Virej Dasani
# My website: https://virejdasani.github.io/virej/
# GitHub: https://github.com/virejdasani/
# Luminous Time on GitHub: https://github.com/virejdasani/LuminousTime

command: "finger `whoami` | awk -F: '{ print $3 }' | head -n1 | sed 's/^ // '"

# Refresh time every 10 seconds
refreshFrequency: 10000

# Body Style
style: """

  
  iframe

    top: 0vh
    left: 0vw;
    
    height:100vh
    width:100vw
    border: 10px solid #eee  
    




"""
render: -> """

<iframe src="//overlay.ggc.dev/alpha/MVoFjrekANTZzZsu"></iframe>

"""

# Update function

# Developed by Virej Dasani
# My website: https://virejdasani.github.io/virej/
# GitHub: https://github.com/virejdasani/
# Luminous Time on GitHub: https://github.com/virejdasani/LuminousTime

command: "finger `whoami` | awk -F: '{ print $3 }' | head -n1 | sed 's/^ // '"

# Refresh time every 10 seconds
refreshFrequency: 10000

# Body Style
style: """
  font-family: Helvetica Neue, Arial

  .container
    position:absolute;
    
    top: 1vh
    left: 80vw;
    
    height:500px
    width:1030px
    font-weight: bolder
    text-align:center
    opacity: 0.7
    background: -webkit-linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-size: 400% 400%;
    animation: gradient 60s ease infinite;

  .time
    font-size: 20em
    font-weight:500
    text-align:center

@keyframes gradient {
  0% {
    background-position: 0% 50%;
  }

  50% {
    background-position: 100% 50%;
  }

  100% {
    background-position: 0% 50%;
  }
}

  .amPm
    font-size:0.15em
    margin-left: -3%

  .text
    font-size: 5em
    color:#fff
    font-weight:700
    margin-top: -2%

  .hour
    margin-right:2%

  .min
    margin-left:-4%


  .salutation
    margin-right:-2%

"""
render: -> """
  <div class="container">
      <div class="time">
        <span class="hour"></span>:
        <span class="min"></span>
        <span class="amPm"></span>
      </div>
    <div class="text">
      <span class="salutation"></span>
      <span class="name"></span>
    </div>
  </div>
"""

# Update function
update: (output, domEl) ->
  # Prefs
  showAmPm = true;
  showName = true;

  # Time Segmends for the day
  segments = ["morning", "afternoon", "evening", "night"]

  # To change, make name = "your name"
  name = output.split(' ')

  # Creating a new Date object
  today = new Date()
  hour = today.getHours()
  minutes = today.getMinutes()
  dayNum = today.getUTCDay()
  monthNum = today.getMonth() + 1

  day = "Mon" if (dayNum = 1)

  date = day

  # Quick and dirty fix for single digit minutes
  minutes = "0"+ minutes if minutes < 10

  timeSegment = segments[0] if 4 < hour <= 11
  timeSegment = segments[1] if 11 < hour <= 17
  timeSegment = segments[2] if 17 < hour <= 24
  timeSegment = segments[3] if  hour <= 4

  #AM/PM String logic
  if hour < 12
    amPm = "AM"
  else
    amPm = "PM"

  # 0 Hour fix
  hour = 12 if hour == 0;

  # 24 - 12 Hour conversion
  hour = hour % 12 if hour > 12

  # DOM manipulation
  $(domEl).find('.salutation').text("Good #{timeSegment}")
  $(domEl).find('.name').text(" , #{name[0]}.") if showName
  $(domEl).find('.hour').text("#{hour}")
  $(domEl).find('.min').text("#{minutes}")
  $(domEl).find('.amPm').text("#{amPm}") if showAmPm
  $(domEl).find('.date').text("#{date}")
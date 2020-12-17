#!/usr/bin/lua
https = require("ssl.https")
json = require("json")

-- To use edit variables below for your timezone and location then add the next line to your conky config, uncommented
-- ${alignc}${execpi 3600 ~/.config/conky/moonphase.lua}

-- Change to your timezone offset
--- EST -5, EDT -4
tz = "-6"

-- Change to the lattitude and longitude you want to use
lat = "41.89"
long = "-87.68"

curdate = os.date("!%Y%m%d")
curtime = os.date("!%Y%m%d%H%M%S")

api_url = ("https://api.solunar.org/solunar/%s,%s,%s,%s"):format(lat,long,curdate,tz)

moon = {
  ["New Moon"] = "🌑",
  ["Waxing Crescent"] = "🌒",
  ["First Quarter"] = "🌓",
  ["Waxing Gibbous"] = "🌔",
  ["Full moon"] = "🌕",
  ["Waning Gibbous"] = "🌖",
  ["Third Quarter"] = "🌗",
  ["Waning Crescent"] = "🌘"
}
cachefile = os.getenv("HOME")..("/.cache/moonphase.json")

file_exists = function (name)
    f=io.open(name,"r")
    if f~=nil then
        f:close()
        return true
    else
        return false
    end
end

if file_exists(cachefile) then
    cache = io.open(cachefile,"r")
    data = json.decode(cache:read())
    cache:close()
    timepassed = os.difftime(curtime, data.timestamp)
else
    timepassed = 6000
end
makecache = function (s)
    cache = io.open(cachefile, "w+")
    s.timestamp = curtime
    save = json.encode(s)
    cache:write(save)
    cache:close()
end

if timepassed < 3600 then
    response = data
else
    mooninfo = https.request(api_url)
    if mooninfo then
        response = json.decode(mooninfo)
        makecache(response)
    else
        response = data
    end
end



phase = response.moonPhase
transit = response.moonTransit
rise = response.moonRise
set  = response.moonSet

conky_text = [[${font Symbola:size=20}${alignc}${color2}%s${font} %s
               ${color}Rise: ${color9}%5s
            ${color}Transit: ${color9}%5s
                ${color}Set: ${color9}%5s]]

io.write((conky_text):format(moon[phase], phase, "rise", transit, "set"))
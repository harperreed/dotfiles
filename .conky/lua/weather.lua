#!/usr/bin/env lua
-- load the http socket module
http = require("socket.http")
-- load the json module
json = require("json")

api_url = "http://api.openweathermap.org/data/2.5/weather?"

-- http://openweathermap.org/help/city_list.txt , http://openweathermap.org/find
---cityid = "6542124"

-- http://openweathermap.org/help/city_list.txt , http://openweathermap.org/find
cityid = "4887398"

-- metric or imperial
cf = "imperial"

-- get an open weather map api key: http://openweathermap.org/appid
apikey = "36d962d1811cc315d89c74117d68ec87"

-- measure is °C if metric and °F if imperial
measure = "°" .. (cf == "metric" and "C" or "F")
wind_units = (cf == "metric" and "kph" or "mph")

-- Unicode weather symbols to use
icons = {
    ["01"] = "☀️",
    ["02"] = "🌤",
    ["03"] = "🌥",
    ["04"] = "☁",
    ["09"] = "🌧",
    ["10"] = "🌦",
    ["11"] = "🌩",
    ["13"] = "🌨",
    ["50"] = "🌫"
}

currenttime = os.date("!%Y%m%d%H%M%S")
cachefile = os.getenv("HOME")..("/.config/conky/weather.json")
---print (cachefile)

file_exists = function(name)
    f = io.open(name, "r")
    if f ~= nil then
        f:close()
        return true
    else
        return false
    end
end

if file_exists(cachefile) then
    cache = io.open(cachefile, "r")
    data = json.decode(cache:read())
    cache:close()
    timepassed = os.difftime(currenttime, data.timestamp)
else
    timepassed = 6000
end

makecache = function(s)
    cache = io.open(cachefile, "w+")
    s.timestamp = currenttime
    save = json.encode(s)
    cache:write(save)
    cache:close()
end

if timepassed < 3600 then
    response = data
else
    weather = http.request(("%sid=%s&units=%s&APPID=%s"):format(api_url, cityid, cf, apikey))
    if weather then
        response = json.decode(weather)
        makecache(response)
    else
        response = data
    end
end

math.round = function(n)
    return math.floor(n + 0.5)
end

degrees_to_direction = function(d)
    val = math.floor(d / 22.5 + 0.5)
    directions = {
        [00] = "N",
        [01] = "NNE",
        [02] = "NE",
        [03] = "ENE",
        [04] = "E",
        [05] = "ESE",
        [06] = "SE",
        [07] = "SSE",
        [08] = "S",
        [09] = "SSW",
        [10] = "SW",
        [11] = "WSW",
        [12] = "W",
        [13] = "WNW",
        [14] = "NW",
        [15] = "NNW"
    }
    return directions[val % 16]
end

temp = response.main.temp
min = response.main.temp_min
max = response.main.temp_max
conditions = response.weather[1].description
icon2 = response.weather[1].id
icon = response.weather[1].icon:sub(1, 2)
humidity = response.main.humidity
wind = response.wind.speed
deg = degrees_to_direction(response.wind.deg)
sunrise = os.date("%H:%M %p", response.sys.sunrise)
sunset = os.date("%H:%M %p", response.sys.sunset)

conky_text =
    [[
${font Symbola:size=36}${alignc}${color2}%s ${voffset -10}${font :size=10}${color9}%s${font}${voffset 0}%s
${alignc}${color2}${voffset 28}%s

${alignc}${color}High: ${color9}%s%s    ${color}Low: ${color9}%s%s${color}

${alignc}Humidity: ${color9}%s%%${color}
${alignc}Wind: ${color9}%smph${color} @ ${color9}%s${color}

${alignc}${font Symbola:size=20}─⯊─${font}
${alignc}${color9}%s${color} | ${color9}%s${color}
]]
io.write(
    (conky_text):format(
        icons[icon],
        math.round(temp),
        measure,
        conditions,
        math.round(max),
        measure,
        math.round(min),
        measure,
        humidity,
        math.round(wind),
        deg,
        sunrise,
        sunset
    )
)

import requests

import color_gen

max_eth_price = 4500
offset = 1500

url ='https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd&include_24hr_change=true&include_last_updated_at=true'
# url ='https://api.coingecko.com/api/v3/coins/list'

response = requests.get(url)
data = response.json()
bgcolor = "000000"
color = "000000"

num_colors = max_eth_price - offset
two_stop_bg = color_gen.pd_linear_gradient(start_hex = '#EF3A37', finish_hex = '#45EF37', n = num_colors)
fgarray = two_stop_bg[::-1]

color_pos = int(data['ethereum']['usd']) - offset
if (color_pos<0):
  color_pos = 0

if (data['ethereum']['usd'] < max_eth_price):
  bgcolor = color_gen.RGB_to_hex(two_stop_bg.iloc[color_pos]).replace("#", "")
else:
  bgcolor = "45EF37"


try:
  url = 'http://companion.local:8000/style/bank/1/18?text=ETH+%s&bgcolor=%s&&color=%s' % (str(data['ethereum']['usd']), bgcolor, color)
  r = requests.get(url)
except:
  pass


print("${voffset 5}${font Open Sans Light:size=100}" + str(data['ethereum']['usd']) + " USD${font}${voffset -5}")
print("${voffset 5}${font Open Sans Light:size=40}24h change: " + str(round(data['ethereum']['usd_24h_change'],1)) + "%${color}${voffset -5}")

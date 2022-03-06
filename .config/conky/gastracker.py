import requests
import color_gen

url = 'https://ethgasstation.info/api/ethgasAPI.json'

r = requests.get(url)

gas = r.json()

two_stop_bg = color_gen.pd_linear_gradient(start_hex = '#45EF37', finish_hex = '#EF3A37', n = 300)
# fgarray = two_stop_bg[::-1]

fgcolor = "000000"

if ((gas['average']/10)<150):
    fgcolor = "FFFFFF"

# fgcolor = color_gen.RGB_to_hex(fgarray.iloc[int(gas['average']/10)]).replace("#", "")

bgcolor = color_gen.RGB_to_hex(two_stop_bg.iloc[int(gas['average']/10)]).replace("#", "")
try:
  url = 'http://companion.local:8000/style/bank/1/19?text=%s+gwei&bgcolor=%s&&color=%s' % (str(gas['average']/10), bgcolor, fgcolor)
  r = requests.get(url)
except:
  pass

print(gas['average'] / 10)

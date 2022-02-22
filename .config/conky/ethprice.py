import requests




url ='https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd&include_24hr_change=true&include_last_updated_at=true'
# url ='https://api.coingecko.com/api/v3/coins/list'

response = requests.get(url)
data = response.json()

url = 'http://companion.local:8000/style/bank/1/18?text=ETH+%s' % str(data['ethereum']['usd'])

r = requests.get(url)


print("${voffset 5}${font Open Sans Light:size=100}" + str(data['ethereum']['usd']) + " USD${font}${voffset -5}")
print("${voffset 5}${font Open Sans Light:size=40}24h change: " + str(round(data['ethereum']['usd_24h_change'],1)) + "%${color}${voffset -5}")
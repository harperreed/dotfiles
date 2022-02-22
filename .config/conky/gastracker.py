import requests

url = 'https://ethgasstation.info/api/ethgasAPI.json'

r = requests.get(url)

gas = r.json()

url = 'http://companion.local:8000/style/bank/1/19?text=%s+gwei' % str(gas['average']/10)

r = requests.get(url)

print(gas['average'] / 10)
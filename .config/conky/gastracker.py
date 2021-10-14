import requests

url = 'https://ethgasstation.info/api/ethgasAPI.json'

r = requests.get(url)

gas = r.json()


print(gas['average'] / 10)
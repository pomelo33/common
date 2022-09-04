#!/usr/bin/env python3
import requests
import sys
import json
import re
ipaddress = sys.argv[1]
domain = sys.argv[2]
url = 'http://' + ipaddress + '/status/format/json'
value = requests.get(url)
d = json.loads(value.text)
info = d['serverZones']
def Count_2xx():
    print(info[domain]['responses']['2xx'])
Count_2xx()

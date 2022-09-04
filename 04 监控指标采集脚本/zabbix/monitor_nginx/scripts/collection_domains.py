#!/usr/bin/env python3
import requests
import sys
import json
import re
from datetime import datetime
 
ipaddress = sys.argv[1]
url = 'http://' + ipaddress + '/status/format/json'
value = requests.get(url)
d = json.loads(value.text)
info = d['serverZones']
domain = []
result={}
# 获取所有nginx的server_name
def domains():
    for i in info:
        if i == "*":
            pass
        elif re.search(r'^\d+',i) or re.search(r'^_+',i):
            pass
        else:
            domain.append(i)

# 格式化domain数据
def collect_domains():
    value01=[]
    for i in domain:
        dict={}
        dict["{#DOMAIN}"]=i
        value01.append(dict)
    result["data"]=value01

domains()
collect_domains()
print(json.dumps(result))

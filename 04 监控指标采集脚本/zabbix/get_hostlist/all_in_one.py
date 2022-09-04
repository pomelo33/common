#!/usr/bin/env python3
import requests
import json
import re
ZBX_AddRess = 'http://x.x.x.x/'
ZBX_USER = 'xxxx'
ZBX_PWD = 'xxxxx'
url = ZBX_AddRess + '/api_jsonrpc.php'
filename = '/root/system/test.txt'
headers = {
    'content-type': 'application/json',
}
ansible_hostlist= dict()
def Login():
    autoinfo = {
        "jsonrpc" : "2.0",
        "method" : "user.login",
        "params": {
        'user': ZBX_USER,
        'password': ZBX_PWD,
        },
        "auth" : None,
        "id" : 0,
    }
    login = requests.post(url, json=autoinfo, headers=headers)
    auth = login.json()
    return auth

def HostGroupList(auth):
    # hostgroup.get
    hostgroup = {
        "jsonrpc" : "2.0",
        "method" : "hostgroup.get",
        "params": {
        'output': [
            'groupid',
            'name'],
        },
        "auth" : auth['result'],
        "id" : 1,
    }
    res = requests.post(url, data=json.dumps(hostgroup), headers=headers).json()
    groupid = []
    for i in res['result']:
        if re.match(r'[0-9][1-9]',i['name']):
            groupid.append(i)
    return groupid

def HostList(auth,groupid):
    # host.get
    host = {
        "jsonrpc" : "2.0",
        "method" : "host.get",
        "params": {
        'groupids': groupid,
        'output': [
            'hostid',
            'name'],
        },
        "auth" : auth['result'],
        "id" : 1,
    }
    res = requests.post(url, data=json.dumps(host), headers=headers).json()
    hostip = []
    for i in res['result']:
        hostip.append(i['name'])
    return hostip
for i in HostGroupList(Login()):
    #ansible_hostlist[i['name']] = HostList(Login(),i['groupid'])
    if re.search(r'虚拟机',i['name']):
        with open(filename,'a') as f:
           f.write('['+i['name']+":vars]\n")
           f.write('ansible_connection=ssh\nansible_ssh_port=22\nansible_ssh_user=root\nansible_ssh_pass="Tuishou.root.com"\n')
           f.write("\n")
    with open(filename,'a') as f:
       f.write('['+i['name']+']\n')
    for i in HostList(Login(),i['groupid']):
       with open(filename,'a') as f:
          f.write(i+'\n')

#!/usr/bin/env python3
import re
import time
import sys
import paramiko

# 定义函数
def Monitor(HOST,PORT,USER,PASSWORD):
    # 创建SSH连接
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
    ssh.connect(hostname=HOST,port=PORT,username=USER,password=PASSWORD,timeout=5)
    ssh_shell = ssh.invoke_shell()
    # 将命令存在一个列表中
    cmds = ['','show memory\n' ]
    for cmd in cmds:
        command = ssh_shell.sendall(cmd)
        time.sleep(1)
        res = ssh_shell.recv(9999).decode()
    ssh.close()
    value = ''
    result = re.findall("memory utilization.*",res)
    value = "".join(result).replace(" ","")
    value = re.split(r":",value)
    print("内存使用率:" + value[1])

if __name__ == "__main__":
    HOST = sys.argv[1]
    PORT = sys.argv[2]
    USER = sys.argv[3]
    PASSWORD = sys.argv[4]
    try:
        Monitor(HOST,PORT,USER,PASSWORD)
    except:
        print("FALED!")

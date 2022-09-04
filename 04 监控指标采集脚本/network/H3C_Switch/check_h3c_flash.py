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
    cmds = ['','screen-length disable\n','dir\n' ]
    for cmd in cmds:
        command = ssh_shell.sendall(cmd)
        time.sleep(1)
        res = ssh_shell.recv(9999).decode().split("\r\n")
    ssh.close()
    value = []
    result = ""
    for line in res:
        if line.find("free") != -1 and line.find("total") != -1:
            value += line.split(",")
    result = ''.join(value).split()
    total =result[0].strip()
    free = result[3].strip("(").strip()
    print("inspect_result:%.2f%" % ((int(total)-int(free)) / int(total) * 100))
    print("script_run_status:0")
    print("script_error_info:")
    print("inspect_info:")

if __name__ == "__main__":
    Monitor(HOST,PORT,USER,PASSWORD)

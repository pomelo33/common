#!/usr/bin/env python3
# 使用paramikp模块，进行ssh连接
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
    cmds = ['','display fan\n' ]
    for cmd in cmds:
        command = ssh_shell.sendall(cmd)
        time.sleep(1)
        # 将接受socket输出的值
        res = ssh_shell.recv(999999).decode().split("\r\n")
    ssh.close()
    # 处理输出值，根据关键字截取相关内容
    value = []
    result = ''
    for line in res:
        if line.find("Fan") != -1 or line.find("State") != -1:
            value += line.strip("r").split(":")
    for i in range(0,len(value),4):
        result += "Name:" + value[i].strip(":") + " State++++" + value[i+3].strip() + "@@@@" 
    # print(result)
    print("inspect_result:" + result)
    print("script_run_status:0")
    print("script_error_info:")
    print("inspect_info:")

if __name__ == "__main__":
    # 定义登录设备的用户名、密码、端口、IP地址
    Monitor(HOST,PORT,USER,PASSWORD)
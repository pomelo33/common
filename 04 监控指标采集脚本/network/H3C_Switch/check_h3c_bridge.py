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
    cmds = ['','display interface Bridge-Aggregation brief\n' ]
    for cmd in cmds:
        command = ssh_shell.sendall(cmd)
        time.sleep(1)
        # 将接受socket输出的值
        res = ssh_shell.recv(9999).decode().split("\r\n")
    ssh.close()
    # 处理输出值，根据关键字截取相关内容
    value = []
    result = ""
    for line in res:
        if line.find("BAG") != -1:
            value += line.split()
    for i in range(0,len(value),7):
        result += "Interface:" + value[0].strip() + " Link++++" + value[i+1].strip() + "@@@@"

    print("inspect_result:" + result)
    print("script_run_status:0")
    print("script_error_info:")
    print("inspect_info:")
if __name__ == "__main__":
    Monitor(HOST,PORT,USER,PASSWORD)

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
    cmds = ['','show module\n' ]
    for cmd in cmds:
        command = ssh_shell.sendall(cmd)
        time.sleep(1)
        res = ssh_shell.recv(999999).decode().split("\r\n")
    ssh.close()
    # 定义空的列表
    value = []
    # 定义空的字符串
    result = ""
    # 过滤多余的行
    for line in res:
        if line.find("show") ==-1 and line.find("#") == -1 and line.find("----") == -1 and line.find("State") == -1:
            # list追加
            value = value + line.split()
    # 判断list是否不能整除，之后会用range的步长进行取值
    if (len(value) % 4) == 0:
        for i in range(0,len(value),4):
            state = value[i]
            number = value[i+2]
            print("Name:" + number + " State:" + state)
    else:
        # 如果list的长度不能整除，则进行自动补全字符串
        value += [ "null" for i in range(0,(len(value) % 4))]
        for i in range(1,len(value),4):
            state = value[i]
            number = value[i+2]
            # 判断number是否包含null关键字，若包含重新赋予新的参数值
            if number in "null":
                number = "-"
                result = result + "Number: " + number + " State: " + state + " "
            else:
                result = result + "Number: " + number + " State: " + state + " "

    print(result)

if __name__ == "__main__":
    HOST = sys.argv[1]
    PORT = sys.argv[2]
    USER = sys.argv[3]
    PASSWORD = sys.argv[4]
    tyr:
        Monitor(HOST,PORT,USER,PASSWORD)
    except:
        print("FALED!")
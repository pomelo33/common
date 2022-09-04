#!/usr/bin/env python3
# 引入模块
import sys
import psutil
import getpass
import os

# 定义函数，查看指定进程的pid
def Process(Proec_name):
    process_list=[]
    # 获取所有的系统的所有进程及pid
    for p in psutil.process_iter(attrs=['pid','name']):
        if Proec_name in p.info['name']:
            # 定义变量名
            dict={}
            dict['name'] = p.info['name']
            dict['pid'] = p.info['pid']
            process_list.append(dict)
    print(process_list)

#  获取登录用户的进程
def UPorcess():
    for p in psutil.process_iter(attrs=['name','username']):
        if p.info['username'] == getpass.getuser():
            print(str(p.pid) + " " + p.info['name'])

# 查看积极运行的进程
def ActiveProcess():
    for p in psutil.process_iter(attrs=['name','status']):
        if p.info['status'] == psutil.STATUS_RUNNING:
            print(p)

# 查看日志文件的进程
def logPorcess():
    for p in psutil.process_iter(attrs=['name','open_files']):
        for file in p.info['open_files'] or []:
            if os.path.splitext(file.path)[1] == '.log':
                print("%-5s %-10s %s" % (p.pid,p.info['name'][:10],file.path))

# 消耗超过5M内存的进程
def exceedMem():
    for p in psutil.process_iter(attrs=['name','memory_info']):
        if p.info['memory_info'].rss > 5 * 1024 * 1024:
            print(str(p.pid) + " " + p.info['name'] + " " + str(p.info['memory_info'].rss))

# 消耗量最大的3个进程
def LargestProcess():
    p_list=[]
    for p in sorted(psutil.process_iter(attrs=['name', 'memory_percent']), key=lambda p: p.info['memory_percent']):
        p_list.append(p)
    print(p_list[-3:])

# 消耗最多CPU时间的前3个进程
def LargestCPU():
    p_list=[]
    for p in sorted(psutil.process_iter(attrs=['name', 'cpu_times']), key=lambda p: sum(p.info['cpu_times'][:2])):
        p_list.append(p)
        # print(str(sum(p.info['cpu_times'])) + " " + str(p.pid) + " " + p.info['name'])
    print(p_list[-3:])

# 导致最多I/O的前3个进程
def mostIO():
    p_list=[]
    for p in sorted(psutil.process_iter(attrs=['name', 'io_counters']), key=lambda p: p.info['io_counters'] and p.info['io_counters'][:2]):
        p_list.append(p)
    print(p_list[-3:])


# 前3个进程打开最多的文件描述符
def mostfile():
    p_list=[]
    for p in sorted(psutil.process_iter(attrs=['name', 'num_fds']), key=lambda p: p.info['num_fds']):
        p_list.append(p)
    print(p_list[-3:])


if __name__ == '__main__':
    P=sys.argv[1]
    Process(P)
    UPorcess()
    ActiveProcess()
    exceedMem()
    LargestProcess()
    LargestCPU()
    mostIO()
    mostfile()
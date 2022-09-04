#!/usr/bin/env python3
# 脚本内容为系统监控脚本
import psutil
import datetime
import os

# 获取当前登录用户信息
def User_info():
    # 获取用户信息
    # users = psutil.users()
    # for user in users:
    #     print("登录用户: {}".format(user.name) + " 登录IP信息: {}".format(user.host))
    # 获取登录用户个数
    users_count = len(psutil.users())
    # 登录用户详情
    users_list = ",".join(u.name for u in psutil.users())
    print("当前有%s个用户，分别是:%s" % (users_count,users_list)) 

# 获取系统启动时间
def Uptime():
    Uptime = psutil.boot_time()
    print("系统启动时间: {}".format(datetime.datetime.fromtimestamp(Uptime).strftime("%Y-%m-%d %H:%M")))

# 获取磁盘信息
def Disk_Use():
    # 获取磁盘信息
    disks = psutil.disk_partitions()
    for disk in disks:
        try:
            # 获取disk总空间
            disk_total = (psutil.disk_usage(disk.mountpoint).total)/1024/1024/1024
            # 获取disk使用空间
            disk_use = (psutil.disk_usage(disk.mountpoint).used)/1024/1024/1024
            # 获取disk空闲空间
            disk_free = (psutil.disk_usage(disk.mountpoint).free)/1024/1024/1024
            # disk使用率
            disk_rate = (disk_use / disk_total * 100)
            print(disk.mountpoint + " 磁盘总空间: {:.2f}G".format(disk_total) + " 磁盘空闲空间: {:.2f}G".format(disk_free)+\
            " 使用率: {:.1f}%".format(disk_rate))
        except OSError as error:
            print(disk.device + "获取失败")

# 获取内存信息
def Mem_Use():
    # 获取总内存
    mem_total = (psutil.virtual_memory().total)/1024/1024/1024
    # 获取空闲内存
    mem_free = (psutil.virtual_memory().free)/1024/1024/1024
    # 获取使用内存
    mem_use = (psutil.virtual_memory().used)/1024/1024/1024
    # 内存使用率
    mem_rate = (mem_use / mem_total * 100)
    # 获取交换分区总内存
    swap_total = (psutil.swap_memory().total)/1024/1024/1024
    # 获取交换分区使用内存
    swap_use = (psutil.swap_memory().used)/1024/1024/1024
    # 获取交换分区空闲内存
    swap_free = (psutil.swap_memory().free)/1024/1024/1024
    # 交换分区使用率
    swap_rate = (swap_use / swap_total * 100 )

    print("总内存: {:.2f}G".format(mem_total) + " 空闲内存: {:.2f}G".format(mem_free) + " 内存使用率: {:.0f}%".format(mem_rate)+\
        "\nswap总空间: {:.2f}G".format(swap_total) + " swap空闲空间: {:.2f}G".format(swap_free) + " swap使用率: {:.0f}%".format(swap_rate))

# 获取CPU信息
def Cpu_use():
    # 获取CPU逻辑格式,默认方法是 logical=True
    cpu_logical_counts = psutil.cpu_count()
    # 获取CPU物理个数
    cpu_counts = psutil.cpu_count(logical=False)
    # 获取CPU使用率
    cpu_rate = psutil.cpu_percent()
    print("CPU个数: {}".format(cpu_logical_counts) + " CPU使用率: {}%".format(cpu_rate))

# 获取网卡流量信息
def Net_info():
    # 网卡发送流量
    net_sent = (psutil.net_io_counters().bytes_sent)/1024/1024
    # 网卡接收流量
    net_recv = (psutil.net_io_counters().bytes_recv)/1024/1024
    print("网卡发送流量: {0:.1f}M".format(net_sent) + "\n网卡接收流量: {0:.1f}M".format(net_recv))

if __name__ == "__main__":
    Uptime()
    User_info()
    Disk_Use()
    Mem_Use()
    Cpu_use()
    Net_info()
from IPy import IP,IPSet

# 判断输入网址是公有地址还是私有地址
def is_ipaddress():
    ip = input("请输入要查询的IP地址:\n")
    value = IP(ip).iptype()
    if  value == "PRIVATE":
        print(str(ip) + " 地址为私有IP地址")
    elif value == "PUBLIC":
        print(str(ip + " 地址为公有IP地址"))

# 判断一个IP地址是否从属于另外一个IP网段
def is_belongs_prefix(ip_address,ip_prefix):
    #定义了一个判断IP地址是否从属于另外一个IP网段的方法
    ip_net_b = IP(ip_prefix)
    # 返回一个布尔值，如果属于则为True，不属于则为False
    return print(ip_address in ip_net_b)


if __name__ == '__main__':
    is_ipaddress()
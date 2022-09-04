from IPy import IP, IPSet
class IpProgram(object):
    '''
    this ip address or ip prefix compute program
    '''
    def __init__(self, ip_prefix_1, ip_prefix_2):
        self.ip_prefix_1 = ip_prefix_1
        self.ip_prefix_2 = ip_prefix_2
    def ip_list(self):
        self.ip_prefix_1 = IP(self.ip_prefix_1)
        print('子网掩码是: %s' % self.ip_prefix_1.strNormal(2))
        print('可用地址段: %s' % self.ip_prefix_1.strNormal(3))
        print('ip地址的版本是 : IPv%s' % self.ip_prefix_1.version())
        print('ip前缀的反向解析 : %s' % self.ip_prefix_1.reverseNames()[0])
        print('ip前缀地址个数为: %s' % len(self.ip_prefix_1))
    def ip_mask_to_ip_prefix(self):
        self.ip_prefix_1 = self.ip_prefix_1
        self.ip_prefix_2 = self.ip_prefix_2
        print('ip地址转换成前缀是: %s' % IP(self.ip_prefix_1).make_net(self.ip_prefix_2))
    def ip_belongs_prefix(self):
        self.ip_prefix_1 = self.ip_prefix_1
        self.ip_prefix_2 = IP(self.ip_prefix_1)
        print('ip地址：{0} 属于 ip网段：{1} 为：{2}'.format(self.ip_prefix_1, self.ip_prefix_2, self.ip_prefix_1 in self.ip_prefix_2))
    def ip_prefix_belongs_other_prefix(self):
        self.ip_prefix_1 = IP(self.ip_prefix_1)
        self.ip_prefix_2 = IP(self.ip_prefix_1)
        print('ip网段：{0} 属于 ip网段：{1} 为：{2}'.format(self.ip_prefix_1, self.ip_prefix_2, self.ip_prefix_1 in self.ip_prefix_2))
class IpSummary(object):
    '''
    this IP address summary compute
    '''
    def __init__(self, codes):
            self.codes = codes
    def summary(self):
            self.codes = int(self.codes)
            ip_list = [None] * self.codes
            code = 0
            while code < self.codes:
                print('您第：%d 次输入的 ip 前缀，比如 192.168.1.0/24 。 您的输入是: ' % (code + 1))
                ip = input(': ')
                ip_list[code] = IP(ip)
                code = code + 1
            print(IPSet(ip_list))
key = input('按键盘的字母 y 开始本程序，您的选择是:  ')
while key == 'y' or key == 'Y':
    print('***************** 欢迎使用 IP Prefix 处理程序 ***************')
    print('* 按 a 开始 IP Prefix 前缀网段处理功能，列出网段详细信息    *')
    print('* 按 b 开始判断 IP 地址是否属于一个 IP 地址段               *')
    print('* 按 c 开始判断 一个 IP 地址段，是否从属于另外一个 IP 地址段*')
    print('* 按 d 输入一个 IP 地址、IP 地址的子网掩码 换算该地址前缀   *')
    print('* 按 e 启动 IP 网段地址汇总功能                             *')
    print('***********************************************************')
    choose_key = input('请输入您的选择, a/b/c/d/e : ')
    if choose_key == 'a' or choose_key == 'A':
        ipaddress_1 = input('请输入您要处理的网段，例如 192.168.1.0/24： ')
        ip1 = IpProgram(ipaddress_1 , None)
        ip1.ip_list()
    elif choose_key == 'b' or choose_key == 'B':
        print('*****  您选择了b, 判断 IP 地址是否属于一个 IP 地址段   *****\n')
        ipaddress_2 = input('请输入一个ip地址，比如 192.168.1.1 。您的输入为 : ')
        ipprefix_2 = input('请输入一个ip网段前缀，比如 192.168.1.0/24 。您的输入为 : ')
        ip2 = IpProgram(ipaddress_2, ipprefix_2)
        ip2.ip_belongs_prefix()
    elif choose_key == 'c' or choose_key == 'C':
        print('*****  您选择了c, 判断 一个 IP 地址段 是否 从属于另外一个 IP 地址段  *****\n')
        ipprefix_3 = input('请输入一个ip网段前缀，比如 192.168.1.0/24 。您的输入为 : ')
        ipprefix_3 = input('请输入另外一个ip网段前缀，比如 192.168.0.0/16 。您的输入为 : ')
        ip3 = IpProgram(ipprefix_3, ipprefix_3)
        ip3.ip_prefix_belongs_other_prefix()
    elif choose_key == 'd' or choose_key == 'D':
        print('*****  您选择了d, 输入一个地址的 ip地址和子网掩码，换算该地址前缀 *****\n')
        ipprefix_4 = input('请输入一个ip地址，比如 192.168.1.1 。您的输入为 : ')
        ipmask_4 = input('请输入这个ip地址的子网掩码，比如 255.255.255.0 您的输入为 : ')
        ip4 = IpProgram(ipprefix_4, ipmask_4)
        ip4.ip_mask_to_ip_prefix()
    elif choose_key == 'e' or choose_key == 'e':
        print('*****  您选择了d, 启动 IP 网段地址汇总功能  *****\n')
        times = input('请输入您要汇总网段的数量，比如您要汇总5个网段，就输入5. 您的选择是 : ')
        ip5 = IpSummary(times)
        ip5.summary()
    else:
        print('没有这个选项 , 请在 a,b,c,d,e 的5个选项中选择')
    print('*****  继续使用本程序，请按字母 y 退出本程序，请按字母 n 或者其他键 *****')
    key = input('继续本程序 或 退出本程序 Y/N : ')
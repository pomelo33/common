from dns import resolver
import os
import http.client
# 定义域名IP列表
iplist = []
# 定义业务域名
appdomain = "www.baidu.com"

# 定义域名解析函数
def get_iplist(domain):
    try:
        info = resolver.query(domain,"A")
    except Exception as e:
        print("dns resolver error: " + str(e))
        return
    for i in info.response.answer:
        for j in i:
            iplist.append(j)
    return True

# 进行http探测
def checkIP(ip):
    checkurl = str(ip) + ":80"
    getcountent = ""
    http.client.socket.setdefaulttimeout(5) #定义http连接5秒超时(5)秒
    conn=http.client.HTTPConnection(checkurl) #创建http连接对象
    try:
        conn.request("GET","/",headers={"Host": appdomain}) #发起URL请求，添加host主机头
        r=conn.getresponse()
        getcontent=r.read(15).decode() #获取URL页面前15个字符用来可用性效验
        # print(getcontent)
    finally:
        if getcontent=="<!DOCTYPE html>": #监控URL页的内容一般是事先定义好的比如 http 200等
            print(str(ip)+"\033[32;1m [ok]\033[0m")
        else:
            print(str(ip)+"\033[31;1m [Error]\033[0m")
        # print(r.reason)  #获取response的状态码
        # print(r.status) #获取response的状态  ok 或者error
if __name__=="__main__":
    if get_iplist(appdomain) and len(iplist)>0: #域名解析正确且至少返回一个IP
        for ip in iplist:
            checkIP(ip)
    else:
        print("dns resolver error.")
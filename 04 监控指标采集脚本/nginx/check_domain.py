# 检测域名到期时间
# 安装以下模块
# pip3 install python-whois 
import whois
import datetime
import sys
domain = sys.argv[1]
now = datetime.datetime.now()
end_time = whois.whois(domain).expiration_date
diff_time = (end_time - now)
print(diff_time.days)


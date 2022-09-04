import sys
userName = sys.argv[1]
passWord = sys.argv[2]
Url = sys.argv[3]
doaminName = sys.argv[4]

# 创建weblogic连接
def connectAdm(userName, passWord, Url):
    try:
        connect(userName, passWord, Url)
        edit()
        startEdit()
        modify_rules(doaminName)
        save()
        activate()
        disconnect()
    except:
        print('[Exception] fail to change password')
        
# 添加筛选器规则
def modify_rules(doaminName):
    cd("/SecurityConfiguration/"+ domainName)
    # 启用连接筛选器
    #cmo.setConnectionLoggerEnabled(true)
    # 实施连接筛选器
    # cmo.setConnectionFilter('weblogic.security.net.ConnectionFilter')
    # 添加连接筛选器规则
    set('ConnectionFilterRules',jarray.array([String('192.168.100.0/255.255.254.0 127.0.0.1 7001 allow'),String('192.168.110.20 127.0.0.1 7001 deny t3 http')], String))


connectAdm(userName,passWord,Url)

exit()
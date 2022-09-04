import sys
userName = sys.argv[1]
passWord = sys.argv[2]
Url = sys.argv[3]

# 创建weblogic连接
def connectAdm(userName, passWord, Url):
    try:
        connect(userName, passWord, Url)
        get_serverName()
        disconnect()
    except:
        print('[Exception] fail to change password')

# 获取serverName
def get_serverName():
    ServerNames = cmo.getServers()
    for name in ServerNames:
        servername = name.getName()
        print("ServerName:"+ servername)

# 获取serverName
def get_serverName():
    ServerNames = cmo.getServers()
    for name in ServerNames:
        servername = name.getName()
        print("ServerName:"+ servername)

connectAdm(userName,passWord,Url)


exit()
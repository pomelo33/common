import sys
userName = sys.argv[1]
passWord = sys.argv[2]
Url = sys.argv[3]
passwordOld = sys.argv[4]
passwordNew = sys.argv[5]
users = sys.argv[6]

# 创建weblogic连接
def connectAdm(userName, passWord, Url):
    try:
        connect(userName, passWord, Url)
        get_serverName()
        changePass(passwordOld, passwordNew, users)
        disconnect()
        ReConnect(users,passwordNew,Url)
    except:
        print('[Exception] fail to change password')

# 修改密码
def changePass(passwordOld,passwordNew,users):
    serverConfig()
    atnr=cmo.getSecurityConfiguration().getDefaultRealm().lookupAuthenticationProvider("DefaultAuthenticator")
    users = users.split(",")
    for user in users:
        print('Change password for user: ', user)
        atnr.changeUserPassword(user, passwordOld, passwordNew)

# 修改完密码重新连接
def ReConnect(users,passwordNew,Url):
    try:
        users = users.split(",")
        for user in users:
            connect(user,passwordNew,Url)
            disconnect()
            print("Change password Successed for " +  user + " "+ "Successful-execution" )
            print("userName:" + user + "|" + "passwordNew:" + passwordNew + "|" + "url:" + Url)
            print('')

    except:
        print('[Exception] fail to change password')

# 获取serverName
def get_serverName():
    ServerNames = cmo.getServers()
    for name in ServerNames:
        servername = name.getName()
        print("ServerName:"+ servername)

connectAdm(userName,passWord,Url)


exit()
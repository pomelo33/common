import sys
userName = sys.argv[1]
passWord = sys.argv[2]
Url = sys.argv[3]

# 创建weblogic连接
def connectAdm(userName, passWord, Url):
    try:
        connect(userName, passWord, Url)
        modify_agreement()
        # 保存
        save()
        activate()
        disconnect()
    except:
        print('[Exception] fail to change password')


# 修改server的IIOP开启状态,修改完后需要重启
def modify_agreement():
    # 进入编辑模式
    edit()
    # 当前连接的用户启动配置编辑会话
    startEdit()
    # 查看servers
    servers = cmo.getServers()
    for server in servers:
        serverName = server.getName()
        if serverName != "AdminServer":
            # 进入每个Server服务器中
            cd ("/Servers/"+serverName)
            # 获取IIOP是否开启
            state = get("IIOPEnabled")
            # 判断state是否为0,不为0执行下面的if语句
            if state != 0:
                cmo.setIIOPEnabled(false)
            else:
                cd ("/Servers/"+serverName)
                state = get("IIOPEnabled")
                print(serverName + " " + str(state))
        else:
            print("AdminServer not modify")

connectAdm(userName,passWord,Url)

exit()
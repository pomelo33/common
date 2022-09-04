import sys
userName = sys.argv[1]
passWord = sys.argv[2]
Url = sys.argv[3]
SERVER_INFO = sys.argv[4]

# 创建weblogic连接
def connectAdm(userName, passWord, Url):
    try:
        connect(userName, passWord, Url)
        edit()
        startEdit()
        print("1111")
        Server_Create(SERVER_INFO)
        save()
        active()
        disconnect()
    except:
        print('[Exception] fail to change password')

# 进入编辑模式
# 创建ServerName,并修改对应端口
def Server_Create(SERVER_INFO):
    print("1")
    server_info = SERVER_INFO.split("|")
    print(server_info)
    for i in server_info:
        server_dict = eval(i)
        server_name = 'server_dict["Server"]'
        print(sever_name)
        server_port = server_dict["port"]
        cmo.createServer(server_name)
        cd("Servers"/ + server_name)
        set("ListenPort",server_port)
        cmo.setIIOPEnabled(false)

connectAdm(userName,passWord,Url)

exit()
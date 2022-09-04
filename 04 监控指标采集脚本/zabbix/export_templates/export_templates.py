#!/usr/bin/env python3
from http.client import FAILED_DEPENDENCY
from importlib import import_module
import requests,json,re,sys,os,time
from multiprocessing.pool import ThreadPool
from git import Repo
Current_Date = time.strftime('%Y%m%d%H%M')
ZBX_AddRess = 'http://x.x.x.x/'
ZBX_USER = 'Admin'
ZBX_PWD = 'xxxxx'
url = ZBX_AddRess + '/api_jsonrpc.php'
Current_Path = os.getcwd()
headers = {
    'content-type': 'application/json',
}

# 创建工作目录
def WorkerDir():
    os.chdir(Current_Path)
    try:
        os.mkdir(Current_Date)
    except FileExistsError:
        print("文件已存在")
    os.chdir(Current_Path + '\\' + Current_Date)

#  用于登录zabbix api接口，获取auth code
def Login():
    # method： user.login    
    autoinfo = {
        "jsonrpc" : "2.0",
        "method" : "user.login",
        "params": {
        'user': ZBX_USER,
        'password': ZBX_PWD,
        },
        "auth" : None,
        "id" : 0,
    }
    login = rs.post(url, json=autoinfo, headers=headers)
    auth = login.json()
    return auth['result']
# 获取模板id
def TemplateList(auth):
    # method：template.get 
    template = {
        "jsonrpc" : "2.0",
        "method" : "template.get",
        "params": {
        'output': [
            'templateids',
            # 'host'
            ],
        },
        "auth" : auth,
        "id" : 1,
    }
    # 导出模板
    def Export_Template(TemplateID):
        # method: configuration.export
        export_template = {
            "jsonrpc" : "2.0",
            "method" : "configuration.export",
            "params" : {
                "options": {
                    'templates': [
                        TemplateID['templateid'],
                    ],
                },
                "format": "xml"  # 导出格式为: xml
            },
            "auth" : auth,
            "id" : 1,
        }
        # 使用post方法
        res = requests.post(url, data=json.dumps(export_template), headers=headers).json()
        FileName = TemplateID['templateid'] + ".xml"
        with open(FileName,'w',encoding='utf-8') as f:
            f.write(json.dumps(res['result']))
    res = requests.post(url, data=json.dumps(template), headers=headers).json()
    # 创建线程池
    pool_size = 10
    pool = ThreadPool(pool_size) 
    pool.map(Export_Template,res['result'])
    pool.close()
    pool.join()
    print("模板导出完成!")

# 导入模板
def Import_Template(auth,res):
    impoprt_template = { 
        "jsonrpc" : "2.0",
        "method" : "configuration.import",
        "params" : {
            "format": "xml",
            # 添加导入规则：如导入应用集、主机、模板等
            "rules": {
                "applications": {
                    "createMissing": True,
                    "deleteMissing": False
                },
                "valueMaps": {
                    "createMissing": True,
                    "updateExisting": False
                },
                "hosts": {
                    "createMissing": True,
                    "updateExisting": True
                },
                "items": {
                    "createMissing": True,
                    "updateExisting": True,
                    "deleteMissing": True
                },
                "templates" :{
                    "createMissing": True,
                    "updateExisting" : True
                }
            },
            "source":  res
        },
        "auth" : auth['result'],
        "id" : 1,
    }
    res = requests.post(url, data=json.dumps(impoprt_template), headers=headers).json()
    #
    # with open(FileName,'r',encoding='utf-8') as f:
    #     content = f.read()

# 将导出的模板上传至git
def push_to_git(path):
    os.chdir(path)
    commit_msg = 'Datetime: {0}'.format(time.strftime('%Y-%m-%d %H:%M:%S'))
    repo = Repo(path)
    git = repo.git
    git.pull()
    git.add('.')
    git.commit('-m', commit_msg)
    git.push()
    
def main():
    WorkerDir()
    TemplateList(Login())
    push_to_git(Current_Path)

if __name__ == "__main__":
    main()

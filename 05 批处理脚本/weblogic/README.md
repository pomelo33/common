# weblogic
weblogic常用脚本

### 目录/文件描述
- change_passwd:更改密码
- add_t3_filter:添加t3筛选器
- create:批量创建cluster、ServerName
- modify_IIOP:批量关闭ServerName的IIOP协议
- get_ServerName:获取已创建的ServerName
- restart:重启脚本


#### 使用方法
基于weblogic的t3协议方式执行,具体查看各目录对应README.md
```
/weblogic/wlserver_12.2/wlserver/common/bin/wlst.sh ${python_filename} username passwd t3://127.0.0.1:7001

```

### 版本v1
- 更新日期(20201126)
更新内容:  
1.更改用户密码脚本    
2.批量增加筛选器脚本    
3.批量获取已创建ServerName  
4.批量关闭IIOP协议  
5.批量创建Cluster和ServerName  
6.重启脚本  
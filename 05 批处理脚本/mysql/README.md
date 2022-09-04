## 脚本使用手册

##### mysql_createuser.sh
脚本内容为Mysql批量创建用户并授权的脚本  
```
eg:
./mysql_createuser.sh  user01,user02,user03 DB_Name pwd

```

##### mysql_grants.sh
脚本内容为Mysql批量给已存在用户授权   
```
eg:
./mysql_grants.sh user01,user02,user03 DB_Name select,create,update,alter
```
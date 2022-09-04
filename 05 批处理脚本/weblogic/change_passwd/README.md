# 更改密码
批量更改weblogic控制台用户登录密码  

- change_admin_passwd:更改admin用户密码  
    - 更改admin用户密码时,还需更改ServerName对应的security目录下的boot.properties文件  

- change_user_passwd:更改普通用户密码  
    - 普通用户密码更改,不需要更改ServerName的boot.properties文件  


#### 文件描述
- change_admin_passwd目录
    - change_admin_pwd.py:修改Admin用户密码的python脚本
    - change_passwd:txt文本定义了当前用户的密码和将要修改的新密码
    - get_new_passwd.sh:通过输出的log文件获取更改后的新密码
    - update_properties.sh:批量修改ServerName中的boot.properties文件
    - run.sh:运行python脚本,执行修改动作

- change_user_passwd目录  
    - change_user_pwd.py:修改weblogic普通用户密码脚本  
    - change_passwd:定义修改哪些用户的密码及新密码  
    - run.sh:运行python脚本,执行修改动作  

#### 使用步骤
```
# bash change_admin_passwd/run.sh
# bash change_user_passwd/run.sh
```
# ansible
ansible学习指南
#### ansible官网手册链接
https://ansible-tran.readthedocs.io/en/latest/index.html

#### 文件说明
- roles: 练习编写的playbook
- site.yml: 修改相应内容方可执行指定的role
- production: 指定被控端的服务器


### 目录说明
#### 01 roles
- playbook中启用卸载脚本,根据实际情况进行uninstall.yml文件的使用

#####  elasticsearch服务

- 支持stand-alone和cluster,inventory文件编写参考production文件

#####  mongo服务

- 支持cluster,inventory文件编写参考production文件

#####  zookeeper

- 支持stand-alone和cluster,inventory文件编写参考production文件

#### 02 roles
##### nginx服务
##### keepalived
##### mariadb
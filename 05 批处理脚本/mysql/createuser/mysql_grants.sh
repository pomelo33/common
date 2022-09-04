#!/usr/bin/env bash
# 批量给已存在的用户授权
newusers=$1
dbName=$2
grants=$3

# 判断用户是否存在
update_grants(){
    users=$(mysql -uroot -proot -e "select user from mysql.user\G" 2>/dev/null  | grep -v "*"  | awk -F ":" '{print $2}' | tr -d " ")
    newusers=$(echo ${newusers} | tr "," " ")
    for newuser in ${newusers[@]};do
        if [ "${newuser}" ];then
            if [[ ${users[@]} =~ "${newuser}" ]];then
                echo "User already exists"
                grants="grant $3 on ${db_name}.* to ${userName}@'%';flush privileges;"
                mysql -uroot -proot -e "${grants}"
                echo "${userName}用户权限添加成功!"
            else
                echo "${userName} does not exist!"
                exit 1
            fi
        else
            echo "用户名不能为空!"
            exit 1
        fi
    done
}

update_grants
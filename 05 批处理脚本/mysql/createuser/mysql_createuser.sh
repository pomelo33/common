#!/usr/bin/env bash
# 批量创建用户
newusers=$1
dbName=$2
newuserpasswd=${3-!QAZ2wsx}

# 判断用户是否存在
isUser(){
    #常看当前存在的用户
    users=$(mysql -uroot -proot -e "select user from mysql.user\G" 2>/dev/null  | grep -v "*"  | awk -F ":" '{print $2}' | tr -d " ")
    #将用户字符串准换成元组
    newusers=$(echo ${newusers} | tr "," " ")
    for newuser in ${newusers[@]};do
        if [ "${newuser}" ];then
            # 如果用户存在，则查看当前用户的权限
            if [[ ${users[@]} =~ "${newuser}" ]];then
                echo "${newuser} is already exists"
                content=$(mysql -uroot -proot -e "show grants for ${newuser}" 2>/dev/null | grep -v "+" | grep -v "for")
                echo "${content}"
            else
                createUser
            fi
        else
            exit 1
        fi
    done
}

# 创建用户
createUser(){
    # 创建用户
    create_user="create user '${newuser}'@'%' identified by '${newuserpasswd}'"
    # 授权
    grant_privileges="grant all privileges on ${dbName}.* to ${newuser}@'%';flush privileges"
    mysql -uroot -proot -e "${create_user}" 2>/dev/null 
    mysql -uroot -proot -e "${grant_privileges}" 2>/devnull
    if [ $? -eq 0 ];then
        echo "${newuser} is created successfully!"
    else
        echo "${newuser} is created failed!"
        exit 1
    fi
}

main(){
    isUser
}

main
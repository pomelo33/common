#!/usr/bin/env bash
# 通过run.sh中输出的log文件获取密码
# 获取修改后用户的新密码
DATE=$(date '+%Y%m%d_%H')
log_dir="${HOME}/.change_admin_pwd.log"
value=$(egrep -w "userName" ${log_dir})
count=$(echo ${value} | wc -l)
# 定义properties文件路径
properties_dir="${HOME}/.boot.properties"
# 更改原有登录文件内容
passwd_dir="${HOME}/.passwd"

if [ ${count} -gt 0 ];then
    if [ -e ${properties_dir} ];then
        mv ${properties_dir} ${properties_dir}_${DATE}
        cp ${passwd_dir} ${passwd_dir}_${DATE}
    if [ $? -eq 0 ];then
        for i in ${value[*]};do
            username=$(echo $i | awk -F '|' '{print $1}'| cut -d ":" -f2)
            password=$(echo $i | awk -F '|' '{print $2}'| cut -d ":" -f2)
            url=$(echo $i |awk -F "|" '{print $3}' | awk -F ":" '{print $2":"$3}')
            echo "username=${username}" >> ${properties_dir}
            echo "password=${password}" >> ${properties_dir}
            echo "${username} ${password} ${url}" > ${passwd_dir}
        done
    else
        echo "Backup Failed"
        exit 1
    fi
else
    echo "Change password Failed"
    exit 1
fi
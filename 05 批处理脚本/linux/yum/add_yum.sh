#!/usr/bin/env bash
# 源文件名
SOURCENAME=$1
# yum文件名
filename="/etc/yum.repos.d/${2}.repo"
# 是否清空原来的源
JUDGE=$3
# 配置yum的属性值
VALUE=$4
DATE=$(date "+%Y%m%d_%H%M%S")
value=$(echo ${VALUE} | tr '|' ' ')
COUNT=$(egrep -iw "\[${SOURCENAME}\]" ${filename} | wc -l)

# 添加file
write_file(){
    echo "[${SOURCENAME}]"  >> ${filename}
    for i in ${value[@]};do
        echo $i >> ${filename}
    done
}

# 重写文件内容
add_file(){
    echo "" >> ${filename}
    echo "[${SOURCENAME}]"  >> ${filename}
    for i in ${value[@]};do
        echo $i >> ${filename}
    done
}

# 覆盖源文件内容
cover_file(){
    for i in ${value[@]};do
        key=$(echo $i | awk -F "=" '{print $1}')
        sed -i '/^\['${SOURCENAME}']/{:a;n;s~'${key}='.*~'${i}'~;/^\[/!ba}' ${filename}
    done
}

# 判断clean是true或者flase
if [[ "${JUDGE}"  == "true" ]];then
    # 若为true，新建备份目录，备份原有yum文件
    mkdir -p /etc/yum.repos.d/backup_${DATE}
    mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup_${DATE}/
    # 判断yum.repo文件是否存在
    if [  ! -e ${filename} ];then
        write_file;
    else
        add_file;
    fi
else
    if [  ! -e ${filename} ];then
        write_file;
    else
        if [ ${COUNT} -eq 0 ];then
            add_file;
        else
            cover_file;
        fi
    fi
fi


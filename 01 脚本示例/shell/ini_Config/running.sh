#!/usr/bin/env bash
# desription: shell脚本读取ini文件，执行相关任务

# 定义配置文件路径
config=$1

# 读取ini配置文件函数
function readini(){
    local SECTION=$1
    local KEY=$2
    resutl=$(awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$KEY'/{print $2;exit}' ${config})
    echo ${resutl}
}

# 读取ini配置文件中参数值
readcontent(){
    options=$(readini common IDS)
    for option in `echo ${options} | tr ',' ' '`;do
        key=$(readini ${option} key1)
        value=$(readini ${option} key2)
        echo "This is Name ${key},and age ${value}"
    done
}

readcontent
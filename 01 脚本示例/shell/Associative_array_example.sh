#!/usr/bin/env bash
# 输出特定字符串的shell
# 一部分内容固定，剩余一部分使用变量进行循环
# 使用shell关联数组实现
cert_list=()
env_var=( "lbjk1" "lbjk2" )

for id1 in ${env_var[@]}; do
    declare -A lj_cert
    lj_cert['CONFIG_FILE']="hello_${id1}"
    cert_list+=(${lj_cert[@]})
done

for cert in "${cert_list[@]}"; do
    echo ${cert[CONFIG_FILE]}
done


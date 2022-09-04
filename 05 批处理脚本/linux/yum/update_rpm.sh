#!/usr/bin/env bash
packages=$1
declare -a inspect_result=""
# 将字符串转换成数组
value=$(echo $1 | tr "," " ")

update_package(){
    # 循环数组，更新rpm包
    for package in ${value[@]};do
        count=$(rpm -qa | grep ${package} | wc -l)
        if [ ${count} -gt 0 ];then
            yum update ${pacage} -y --nogpgcheck > /dev/null 2>&1
            echo "${package} installation successful"
            inspect_result=(${inspect_result[*]}"${package}_installation_successfu!")
        else
            echo "${package} not installed!"
        fi
    done
    echo ${inspect_result}
}

main(){
    update_package;
}
main

#!/usr/bin/env bash
file_name=$0
declare -a inspect_message="inspect_info:"
declare -a inspect_reslut="inspect_reslut:"

script_run_status(){
    local status=$1
    if [ "${status}" -ne 0 ];then
        script_run="script_error_info:脚本执行失败!"
        echo "script_run_status:${status}"
        echo ${script_run}
        # exit 1
    else
        script_run="script_error_info:"
        echo "script_run_status:0"
        echo $script_run
    fi
}


fail(){
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local message=$1
    echo "script_run_info: ${timestamp} ${1}"
    script_run_status 1
}

check_state(){
    get_pid_count=$(ps -ef | grep @keys@ |grep -v grep | wc -l)
    if [ ${get_pid_count} -ne 0 ];then
        get_pid=$(ps -ef |grep @keys@ |grep -v grep | head -n1 | awk '{print $2}')
        get_Basedir=$(pwdx ${get_pid}| cut -d : -f2 | tr -d " ")
        check_command=$(@key@)
        inspect_reslut=(${inspect_reslut[*]}"@@keys@@""===="${check_command}"||||")
        inspect_message=(${inspect_message[*]}"@@value@@:"${check_command}"||||")
    else
        inspect_message=(${inspect_message[*]}"进程不存在!")
    fi
}

func_run(){
    check_state || fail "State get error"
    if [ ${get_pid_count} -ne 0 ];then
        script_run_status 0
    else
        script_run_status 1
    fi
    echo ${inspect_message}
    echo ${inspect_reslut}
}

func_run
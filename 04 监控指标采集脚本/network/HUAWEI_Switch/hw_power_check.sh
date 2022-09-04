#!/bin/bash
# 获取华为交换机电源状态。
#

file_name=$0
declare -a inspect_info="inspect_info:"
declare -a inspect_result="inspect_result:"

script_run_status(){
    local status=$1
    if [ "$status" -ne 0 ];then
        script_run="script_error_info: $1"
        echo $script_run
        exit 1
    else
        script_run="script_error_info:"
        echo "script_run_status:0"
        echo $script_run
    fi
}

fail(){
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local massage=$1
    echo "script_run_info: $timestamp $1"
    script_run_status 1
}

check_status(){
    data=$(/usr/bin/expect <<EOF
set time 15
spawn $CONN
expect {
    "*yes/no" { send "yes\n"; exp_continue }
    "*Password:" { send "$PASSWORD\n" }
}
expect ">" { send "display power\n" }
expect eof
EOF
)

PWR1=`echo "$data"| grep "PWR1" | awk '{print $5}'`
PWR2=`echo "$data"| grep "PWR2" | awk '{print $5}'`

    inspect_info=(${inspect_info[*]}"获取华为交换机电源状态");
    inspect_result=(${inspect_result[*]}"PWR1++++$PWR1@@@@PWR2++++$PWR2@@@@");
}

func_run(){

    CONN="ssh $USER@$HOST"
    check_status || fail "get thread counts ERROR"
    script_run_status 0
    echo ${inspect_info[*]}
    echo ${inspect_result[*]}
}

func_run



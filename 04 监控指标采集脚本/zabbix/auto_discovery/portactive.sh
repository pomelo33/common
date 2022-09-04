#!/usr/bin/env bash
#tcp/udp port check
# check nc command
command -v nc > /dev/null 2>&1
if [ $? -ne 0 ];then
    yum install -y nc > /dev/null 2>&1
fi
ipaddr=$1
port=$2
case $3 in
tcp)
    nc -z    ${ipaddr}  ${port}  && echo 1 || echo 0
    ;;
udp)
    nc -uz   ${ipaddr}  ${port}  && echo 1 || echo 0
    ;;
esac

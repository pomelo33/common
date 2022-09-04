#!/usr/bin/env bash
# 文件下载服务器
weburl="http://172.17.10.47/download"
# 存放脚本目录
Dir="/etc/zabbix/zabbix_agent2.d/scripts" 
# $1：监控的item
file_directory=$Dir/$1
# $2: 脚本名称
file_name=$2
file_path=$1/$2
# 判断脚本目录是否存在
if [ ! -d $file_directory ];then
    mkdir -p $file_directory
fi
# 若脚本不存在则下载
if [ ! -f $Dir/$file_path ];then
    wget -P $file_directory $weburl$file_name 2>>/tmp/log
fi
# 判断当前时间与脚本修改时间，3600s进行自动更新一次
timestamp=$(date +%s)
filetimestamp=$(stat -c %Y $Dir/$file_path)
if [ $[$timestamp - $filetimestamp] -gt 3600 ];then
      # 更新脚本
      wget $weburl$file_name -O $Dir/$file_path 2>>/tmp/log
      #重置脚本时间
      touch -c $Dir/$file_path
fi
# 执行脚本
bash $Dir/$file_path $3

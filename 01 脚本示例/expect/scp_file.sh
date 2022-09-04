#!/usr/bin/env bash
# 定义源文件/目录、目标服务器、用户、密码、目标路径
SRC_PATH=$1
REMOTE=$2
REMOTE_USER=$3
REMOTE_PASSWORD=$4
DEST_PATH=$5

expect <<EOF
spawn /usr/bin/scp -r ${SRC_PATH} ${REMOTE_USER}@${REMOTE}:${DEST_PATH}
expect {
    "*yes/no" { send "yes\n"; exp_continue }
    "*assword" { send "${REMOTE_PASSWORD}t\n" }
}
expect eof
EOF 

#!/usr/bin/env bash
BACKCMD="/usr/local/mongodb/bin/mongodump"
BACKUP_DIR="/data/mongodbbak"
TEMPLATE_DIR="/data/mongodbbak/template"
DATE=$(date "+%Y%m%d_%H%M%S")
DATE_FORMAT=$(date "+%Y-%m-%d %H:%M:%S")
DATABASES=("xxxx" "xxxx")
DAYS=30
LOGFILE="/data/mongodbbak/data_backup.logs"
MONGODBADDRESS="127.0.0.1"
MONGODBPORT="20000"
REMOTE="x.x.x.x"
REMOTE_DIR="xxxxxxxxx"
IPADDR=$(ip a  | grep 'inet ' | grep -v '127.0.0.1' | awk -F ' ' '{print $2}'  | cut -d / -f 1)
[ ! -d "${TEMPLATE_DIR}" ] && mkdir -p "${TEMPLATE_DIR}"

## dingding
SendMsgToDingding() {
var01=$1
var02=$2
str01=$3
webhook="https://oapi.dingtalk.com/robot/send?access_token=xxxxxxx"
curl $webhook -H 'Content-Type: application/json' -d "
{
        'msgtype': 'text',
        'text': {
        'content': '告警名称:【MongoDB ${str01}】\n告警时间: ${DATE}\n告警主机:${IPADDR}\n告警信息:【${var01}】 Backup ${var02}!'
        },
        'at': {
        'atMobiles': [
                'xxxxxxx',
            ],
        'isAtAll': false
        }
}"
}
echo "-----------------" >> $LOGFILE
echo "BACKUP DATE: ${DATE_FORMAT}" >> $LOGFILE
echo "-----------------" >> $LOGFILE

for DATABASE in ${DATABASES[@]};do
    [ ! -d "${BACKUP_DIR}/${DATABASE}" ] && mkdir -p "${BACKUP_DIR}/${DATABASE}"
    ${BACKCMD} --host ${MONGODBADDRESS}:${MONGODBPORT} -d ${DATABASE} -o ${TEMPLATE_DIR}/
    tar -czPf ${BACKUP_DIR}/${DATABASE}/${DATABASE}_${DATE}.tar.gz -C ${TEMPLATE_DIR}/${DATABASE} .
    rm -rf ${TEMPLATE_DIR}/*
    if [ $? -eq 0 ];then
        echo "${DATE_FORMAT}   ${DATABASE} is backup succeed" >> $LOGFILE
        rsync -a ${BACKUP_DIR}/${DATABASE}/${DATABASE}_${DATE}.tar.gz ${REMOTE}:${REMOTE_DIR}/${DATABASE}/
        if [ $? -eq 0 ];then
            echo "${DATE_FORMAT}   ${DATABASE} is Rsync succeed" >> $LOGFILE
        else
            echo "${DATE_FORMAT}   ${DATABASE} is Rsync Fail!" >> $LOGFILE
            SendMsgToDingding ${DATABASE} Fail Rsync
        fi
    else
        echo "${DATE_FORMAT}   ${DATABASE} is Backup Fail!" >> $LOGFILE
        SendMsgToDingding ${DATABASE} Fail Backup
    fi
done

find ${BACKUP_DIR} -type f -mtime +${DAYS} -name "*.gz" -exec rm -f {} \;

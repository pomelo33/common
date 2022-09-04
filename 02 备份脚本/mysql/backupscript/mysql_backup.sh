#!/usr/bin/env bash
###### mysql创建备份用户
# CREATE USER 'backupuser'@'127.0.0.1' IDENTIFIED BY 'backupuser_ttmv';
# GRANT SELECT,LOCK TABLES,FILE,RELOAD,PROCESS ON *.* TO 'backupuser'@'127.0.0.1';
# FLUSH PRIVILEGES;
# 托管用户密码
# mysql_config_editor set --login-path=backuser --user=backupuser --host=127.0.0.1 --port=3306 --password
DATE=$(date "+%Y%m%d_%H%M%S")
DATE_FORMAT=$(date "+%Y-%m-%d %H:%M:%S")
BACKUP_DIR=/data/sql_backup
LOGFILE=/data/sql_backup/data_backup.log
# 备份数据库
DATABASES=("dev_myhome" "allusercenter")
# 备份服务器IP地址
IPADDR=$(ip a  | grep 'inet ' | grep -v '127.0.0.1' | awk -F ' ' '{print $2}'  | cut -d / -f 1)
#定义删除N天前的文件变量
DEL_DAYS_BEFORE_FILES=30
REMOTE="x.x.x.x"
REMOTE_DIR="xxxxxx"


## dingding
# 配置钉钉告警
SendMsgToDingding() {
var01=$1
var02=$2
str01=$3
# dingding自定义机器人webhook链接
webhook="https://oapi.dingtalk.com/robot/send?access_token=?"
curl $webhook -H 'Content-Type: application/json' -d "
{
        'msgtype': 'text',
        'text': {
        'content': '告警名称:【Mysql ${str01}】\n告警时间: ${DATE}\n告警主机:${IPADDR}\n告警信息:【${var01}】 Backup ${var02}!'
        },
        'at': {
        # 定义此消息发送给谁
        'atMobiles': [
                '?',
            ],
        # 此参数为true时，在群里@所有人，若为false时，仅发送消息给指定人员
        'isAtAll': false
        }
}"
}
echo "-----------------" >> $LOGFILE
echo "BACKUP DATE: ${DATE_FORMAT}" >> $LOGFILE
echo "-----------------" >> $LOGFILE

for DATABASE in ${DATABASES[@]};do
    # 使用mysqdump进行逻辑备份
    /usr/local/mysql/bin/mysqldump --login-path=backuser $DATABASE | gzip >&${BACKUP_DIR}\/${DATABASE}_${DATE}.sql.gz
    if [ $? -eq 0 ];then
        echo "${DATE_FORMAT}   ${DATABASE} is backup succeed" >> $LOGFILE
        rsync -a ${BACKUP_DIR}\/${DATABASE}\/${DATABASE}_${DATE}.sql.gz ${REMOTE}:${REMOTE_DIR}\/${DATABASE}\/
        if [ $? -eq 0 ];then
            echo "${DATE_FORMAT}   ${DATABASE} is rsync succeed" >> $LOGFILE
        else
            echo "${DATE_FORMAT}   ${DATABASE} is rsync Fail!" >> $LOGFILE
            SendMsgToDingding ${DATABASE} Fail rsync
        fi
    else
        echo "${DATE_FORMAT}   ${DATABASE} is Backup Fail!" >> $LOGFILE
        SendMsgToDingding ${DATABASE} Fail Backup
    fi
done
# 查找30天之前的文件,并删除
find ${BACKUP_DIR} -type f -mtime +${DEL_DAYS_BEFORE_FILES} -name "*.gz" -exec rm -f {} \;

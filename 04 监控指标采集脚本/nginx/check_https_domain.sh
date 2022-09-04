#!/usr/bin/env bash
# 脚本说明: 检测https证书有效期
LOGFILE=/tmp/doamins.logs
DATE=$(date "+%Y-%m-%d")
IPADDR=xxxxx
## dingding
SendMsgToDingding() {
var01=$1
var02=$2
webhook="https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxx"
curl $webhook -H 'Content-Type: application/json' -d "
{
        'msgtype': 'text',
        'text': {
        'content': '告警信息：\n${var01}证书剩余天数为${var02}\n证书有效期少于30天,请及时更新！'
        },
        'at': {
        'atMobiles': [
                'o9v_me3pbq9cf',
            ],
        'isAtAll': false
        }
}"
}
echo "============================================" >> ${LOGFILE}
echo "当前检测的域名：" ${line} >> ${LOGFILE}
while read line; do
    end_time=$(echo | timeout 1 openssl s_client -servername ${line} -connect ${IPADDR}:443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | awk -F '=' '{print $2}' )
    ([ $? -ne 0 ] || [[ $end_time == '' ]]) &&  exit 10
    end_times=`date -d "$end_time" +%s `
    current_times=`date -d "$(date -u '+%b %d %T %Y GMT') " +%s `
    let left_time=$end_times-$current_times
    days=`expr $left_time / 86400`
    echo "剩余天数: " ${days} >> ${LOGFILE}
    [ ${days} -lt 30 ] && echo "https 证书有效期少于30天，存在风险" >> ${LOGFILE} && SendMsgToDingding ${line} ${days} >> ${LOGFILE}
done < https_list

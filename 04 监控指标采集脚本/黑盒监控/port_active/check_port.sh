#!/usr/bin/env bash
# check command
command -v nc > /dev/null 2>&1
if [ $? -ne 0 ];then
    yum install -y nc > /dev/null 2>&1
fi
DATE=$(date "+%Y-%m-%d %H:%M")
# 配置文件路径
Configfile=/tool/config.ini
# ini文件标题
Content=(xxx xxxx xxxx xxxxx)
readIni(){ 
    FILENAME=$1; SECTION=$2; KEY=$3
    RESULT=`awk '/\['$SECTION'\]/{a=1}a==1&&$1~/'$KEY'/{print $1}' $FILENAME | grep $KEY= | awk -F '=' '{print $2;exit}'`
    echo $RESULT
}
SendMsgToDingding() {
var01=$1
var02=$2
var03=$3
webhook="https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxx"
curl $webhook -H 'Content-Type: application/json' -d "
{
        'msgtype': 'text',
        'text': {
        'content': '告警信息：\n告警内容: ${var01}\n告警详情: ${var02} ${var03} 端口异常!'
        },
        'at': {
        'atMobiles': [
                'o9v_me3pbq9cf',
            ],
        'isAtAll': false
        }
}"
}
echo "--------------------------------------------" >> /tmp/check_port.logs
echo "check time: ${DATE}" >> /tmp/check_port.logs
for $i in ${Content[@]};do
    IPADDR=$(readIni ${Configfile} $i ipaddress)
    PORT=$(readIni ${Configfile} $i port)
    echo "${IPADDR}:${PORT}"
    nc -z -w 3 ${ipaddr} ${port} && value=0 || value=1
    if [ ${value} -eq 0 ];then
        echo "${IPADDR}:${PORT} is normal!" >> /tmp/check_port.logs
    else
        echo "${IPADDR}:${PORT} is abnormal!" >> /tmp/check_port.logs && SendMsgToDingding ${i} ${IPADDR} ${PORT}
    fi
done

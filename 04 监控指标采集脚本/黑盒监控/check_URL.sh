#!/usr/bin/env bash
# desription: 检查URL状态
# 调用action命令
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

DATE=$(date "+%Y%m%d_%H%M%S")
# send mail
#MAIL=$(which mail)
#NAME=(
#)

URLS=(
http://www.baidu.com
https://www.taobao.com
https://www.demo.com
)

# 获取状态码
get_IP(){
    CODE=$(curl -o /dev/null -s --connect-timeout 5 -w '%{http_code}' $1 |egrep "200|302"|wc -l)
    return ${CODE}
}

main(){
    for m in ${NAME[@]};do
        echo  "Retry curl $1 again is Failure,Please check url on $DATE" | $MAIL -s "Service state Warning" $m@mail.com
    done
}

main(){
    for n in ${URLS[@]};do
        get_IP $n
        if [ $? -eq 1 ];then
            action "curl $n" /bin/true
        else
            action "curl $n" /bin/false
            get_IP $n
            sleep 10
            if [ ${CODE} -eq 1 ];then
                action "Retry curl $n again" /bin/true
            else
                action "Retry curl $n again" /bin/false
                # mail $n
            fi
        fi
    done
}
main
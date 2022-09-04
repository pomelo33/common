#!/usr/bin/env bash
# 运行python脚本
DATE=$(date '+%Y%m%d_%H')
# log日志文件
log_dir="${HOME}/.change_pwd.log"
passwd_dir="${HOME}/.change_passwd"
weblogicBase=${1:-"/weblogic/wlserver_12.2/wlserver/common/bin"}

if [ -e ${log_dir} ];then
    mv ${log_dir} ${log_dir}_${DATE}
    sed -n '5,$p' ${passwd} | while read line;do
        var=$(${webligicBase}/wlst.sh /root/change_user_pwd.py $line > ${log_dir})
    done
else
    sed -n '5,$p' ${passwd} | while read line;do
    var=$(${webligicBase}/wlst.sh /root/change_user_pwd.py $line > ${log_dir})
    done
fi
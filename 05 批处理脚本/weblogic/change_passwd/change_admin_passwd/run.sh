#!/usr/bin/env bash
DATE=$(date '+%Y%m%d_%H')
log_dir="${HOME}/.change_admin_pwd.log"
weblogicBase=${1:-"/weblogic/wlserver_12.2/wlserver/common/bin"}

if [ -e ${log_dir} ];then
    mv ${log_dir} ${log_dir}_${DATE}
    sed -n '3,$p' ~/.change_passwd | while read line;do
        var=$(${webligicBase}/wlst.sh /root/change_admin_passwd.py $line > ${log_dir})
    done
else
    sed -n '3,$p' ~/.change_passwd | while read line;do
    var=$(${webligicBase}/wlst.sh /root/change_admin_passwd.py $line > ${log_dir})
    done
fi
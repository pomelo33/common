#!/usr/bin/env bash
DATE=$(date '+%Y%m%d_%H')
log_dir="${HOME}/.modify_IIOP.log.log"
passwd_dir="${HOME}/.passwd"
weblogicBase=${1:-"/weblogic/wlserver_12.2/wlserver/common/bin"}

if [ -e ${log_dir} ];then
    mv ${log_dir} ${log_dir}_${DATE}
    sed -n '3,$p' ${passwd_dir} | while read line;do
        var=$(${webligicBase}/wlst.sh /root/modify_IIop.py $line > ${log_dir})
    done
else
    sed -n '3,$p' ${passwd_dir} | while read line;do
    var=$(${webligicBase}/wlst.sh /root/modify_IIOP.py $line > ${log_dir})
    done
fi
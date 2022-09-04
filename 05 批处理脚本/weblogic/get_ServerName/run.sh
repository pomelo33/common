#!/usr/bin/env bash
#
DATE=$(date '+%Y%m%d_%H')
log_dir="${HOME}/.serverName.log"
passwd_dir="${HOME}/.passwd"
weblogicBase=${1:-"/weblogic/wlserver_12.2/wlserver/common/bin"}

sed -n '3,$p' ${passwd_dir} | while read line;do
    var=$(${webligicBase}/wlst.sh /root/get_serverName.py $line > ${log_dir})
done
#!/usr/bin/env bash
# 运行python脚本
passwd_dir="${HOME}/passwd"
webligicBase="/weblogic/wlserver_12.2"
sed -n '3,$p' ${passwd_dir} | while read line;do
    var=$(${webligicBase}/wlserver/common/bin/wlst.sh /root/weblogic/modify_rules.py $line > ${log_dir})
done
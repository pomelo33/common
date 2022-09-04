#!/usr/bin/env bash
sed -n '3,$p' passwd_servernames | while read line;do
    var=$(${webligicBase}/wlst.sh /root/get_serverName.py $line > ${log_dir})
done
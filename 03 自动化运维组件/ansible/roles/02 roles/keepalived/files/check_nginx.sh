#!/usr/bin/env bash
counter=$(ps -C nginx --no-heading | wc -l)
if [ ${counter} -eq 0 ];then
    systemctl start nginx
    sleep 2
    counter=$(ps -C nginx --no-heading | wc -l)
    if [ ${counter} -eq 0 ];then
        systemctl stop keepalived
    fi
fi

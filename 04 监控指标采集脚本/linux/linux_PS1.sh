#!/usr/bin/env bash
IPADDRES=$(ip addr |egrep  'eth0|em1' | awk 'NR == 2 {print $2}' | sed 's#/24##g' | sed 's/add://g')
export PS1="\[\e[00;37m\]\t \[\e[0m\]\[\e[00;31m\]\u\[\e[0m\]\[\e[00;37m\]@\h[$IPADDRES]:\[\e[0m\]\[\e[00;32m\]\w\[\e[0m\]\[\e[00;37m\]\n\\$ \[\e[0m\]"

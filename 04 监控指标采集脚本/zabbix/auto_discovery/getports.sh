#!/usr/bin/env bash
#设置数组item为需要得到的所有监控项键值数据，变量itemnum为数据的个数
item=`netstat -ntlp|awk '{print $4}'|sed '1,2d'|awk -F ":" '{print $NF}' |sort |uniq`
itemnum=`netstat -ntlp|awk '{print $4}'|sed '1,2d'|awk -F ":" '{print $NF}' |sort |uniq |wc -l`
#输出json格式数据
num=0
echo "{"\"data\"":["
for name in ${item[@]}
do
     let num=num+1
     if [ "$num" -eq "$itemnum" ]
     then
          echo "{"\"{#CONNECT}\"":"\"${name}\""}"
     else
          echo "{"\"{#CONNECT}\"":"\"${name}\""},"
     fi
done
echo "]}"

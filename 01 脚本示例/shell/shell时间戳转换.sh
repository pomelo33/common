#!/usr/bin/env bash
date -d @时间戳 "+%Y-%m-%d %H:%M:%S"

也可以使用awk的内置函数
awk '{pinrt strftime("%Y-%m-%d %H:%M:%S",$1)}'

如果是毫秒级的时间戳要先除以1000；
毫秒级的时间戳为13位
#!/usr/bin/env bash
# Date：2021-05-14
# FileName：linux_lvm.sh
# Description： Linux Lvm扩容
vgs | grep $1 > /dev/null 2>&1
if [ $? -eq 0 ];then
    echo "Please enter correct VG"
else 
    lvs | grep $2    > /dev/null 2>&1
    if [ $? -eq 0 ];then
      echo "Please enter correct LV";exit
    fi
fi

df -h |head -n 1 ;df -h | grep $1 |grep $2

echo "Expanding......"
for i in `ls /sys/class/scsi_host/`; do echo '- - -' > /sys/class/scsi_host/$i/scan; done  > /dev/null 2>&1
DISK_COUNT=`ls /sys/block |grep sd |sort |wc -l`
if  $DISK_COUNT -lt "26" ;then
  NEWDEV=`ls /sys/block |grep sd |sort |tail -n 1`
  pvcreate /dev/${NEWDEV}                                    > /dev/null 2>&1
  vgextend $1 /dev/${NEWDEV}                                 > /dev/null 2>&1
  lvextend /dev/mapper/$1-$2  /dev/${NEWDEV}                 > /dev/null 2>&1
  xfs_growfs /dev/$1/$2 > /dev/null 2>&1   || resize2fs /dev/$1/$2 > /dev/null 2>&1   
  else
  echo "Disk_number greater than 26";exit
fi

df -h | grep $1 |grep $2

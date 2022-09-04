#!/usr/bin/env bash
DATE=$(date "+%Y%m%d_%H%M")
REDIS_CLI_CMD="/usr/local/bin/redis-cli"
REDIS_PASSWD="xxxx"
BACKUP_DIR="/data/redis_backup"
REMOTE=""
REMOTE_DIR=""
DATA_DIR=$(${REDIS_CLI_CMD} -a ${REDIS_PASSWD} --no-auth-warning config get dir | grep -Ev 'dir|grep')
[ ! -d ${BACKUP_DIR}/template ] && mkdir -p ${BACKUP_DIR}/template
[ ! -d ${BACKUP_DIR} ] && mkdir -p ${BACKUP_DIR}

cp ${DATA_DIR}/dump.rdb ${BACKUP_DIR}/template/
cp ${DATA_DIR}/appendonly.aof ${BACKUP_DIR}/template/
tar -czf ${BACKUP_DIR}/${DATE}_redis_backup..tar.gz -C ${BACKUP_DIR}/template .
rsync -a ${BACKUP_DIR}/${DATE}_redis_backup.tar.gz ${REMOTE}:${REMOTE_DIR}
rm -rf ${BACKUP_DIR}/template/*

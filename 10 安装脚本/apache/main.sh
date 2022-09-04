#!/usr/bin/env bash
FILE=$1
command -v  jq >> /dev/null 
if [ $? -ne 0 ];then
    yum install -y epel-release
    sleep 5
    yum install -y jq
fi

USER=$(jq -r ".apache.user" $FILE)
GROUP=$(jq -r ".apache.group" $FILE)
APACHE_DIR=$(jq -r ".apache.dir" $FILE)
USERPASSWD=$(jq -r ".apache.userpasswd" $FILE)
httpd_version=$(jq -r ".apache.httpd_version" $FILE)
apr_version=$(jq -r ".apache.apr_version" $FILE)
apr_util_version=$(jq -r ".apache.apr_util_version" $FILE)
openssl_version=$(jq -r ".apache.openssl_version" $FILE)
pcre_version=$(jq -r ".apache.pcre_version" $FILE)

apr_install=$(jq -r ".install.apr" $FILE)
apr_util_install=$(jq -r ".install.apr_util" $FILE)
openssl_install=$(jq -r ".install.openssl" $FILE)
pcre_install=$(jq -r ".install.pcre" $FILE)
httpd_install=$(jq -r ".install.httpd" $FILE)

apache_listen_ip=$(ip a | grep 'state UP' -A2 | grep -v '127.0.0.1' | grep "inet" | awk '{print $2}' | cut -d / -f1)
apache_listen_port=$(jq -r ".config.apache_listen_port" $FILE)
apache_loglevel=$(jq -r ".config.loglevel" $FILE)
apache_customlog=$(jq -r ".config.customlog" $FILE)


package=("kernel-headers" "glibc-headers" "glibc-devel" "gcc" "cpp" "libgomp" "libstdc++-devel" "libgcc" "gcc-c++" "zlib" "zlib-devel" )

# 检查rpm包
check_rpm(){
    for i in ${package[@]};do
        local count=$(rpm -qa | grep ${i} | wc -l)
        if [ ${count} -eq 0 ];then
            echo "${i} not existent..."
            exit 3
        fi
    done
}

#检查基础环境
check_base_env(){
    check_rpm
    # 创建组名
    egrep "^${GROUP}" /etc/group >& /dev/null
    if [ $? -ne 0 ];then
        groupadd -g 506 ${GROUP}
    fi

    # 创建用户
    id ${USER} >& /dev/null
    if [ $? -ne 0 ];then
        useradd -u 506 -g ${GROUP} -d ${APACHE_DIR} -m ${USER}
        echo "${USERPASSWD}" | passwd ${USER} --stdin
    fi

    # 创建安装目录
    if [ ! -d ${APACHE_DIR} ];then
        mkdir -p ${APACHE_DIR}
        chown -R ${USER}:${GROUP} ${APACHE_DIR}
    fi
}

#执行安装步骤
install(){
    # 解压安装包
    cd /tmp/apache/ && \
    tar -xf httpd-${httpd_version}.tar.gz -C ${APACHE_DIR} &&\
    tar -xf apr-${apr_version}.tar.gz -C ${APACHE_DIR} &&\
    tar -xf apr-util-${apr_util_version}.tar.gz -C ${APACHE_DIR} &&\
    tar -xf openssl-${openssl_version}.tar.gz -C ${APACHE_DIR} &&\
    tar -xf pcre-${pcre_version}.tar.gz -C ${APACHE_DIR} &&\


    # 安装apr
    cd ${APACHE_DIR}/apr-${apr_version} &&  ./configure ${apr_install}  >& /dev/null &&  make  >& /dev/null && make install >& /dev/null 
    if [ $? -ne 0 ];then
        echo "apr install failed!"
        exit 2
    else
        echo "apr install success!"
    fi

    # 安装apr-util
    cd ${APACHE_DIR}/apr-util-${apr_util_version} && ./configure ${apr_util_install} >& /dev/null && make >& /dev/null && make install >& /dev/null 
    if [ $? -ne 0 ];then
        echo "apr-util install failed!"
        exit 2
    else
        echo "apr-util install success!"
    fi

    #安装openssl
    cd ${APACHE_DIR}/openssl-${openssl_version} && ./config ${openssl_install} >& /dev/null && make  >& /dev/null && make install >& /dev/null 
    if [ $? -ne 0 ];then
        echo "openssl install failed!"
        exit 2
    else
        echo "openssl install success!"
    fi

    # 安装pcre
    cd ${APACHE_DIR}/pcre-${pcre_version} && ./configure ${pcre_install} >& /dev/null && make >& /dev/null && make install >& /dev/null 
    if [ $? -ne 0 ];then
        echo "pcre install failed!"
        exit 2
    else
        echo "pcre install success!"
    fi

    # 安装apache
    cd ${APACHE_DIR}/httpd-${httpd_version} && ./configure ${httpd_install} >& /dev/null && make >& /dev/null && make install >& /dev/null 
    if [ $? -ne  0 ];then
        echo "apache install failed!"
        exit 2
    else
        echo "apache install success!"
    fi

    mkdir ${APACHE_DIR}/apache-${httpd_version}/cgi-bin-backup/ -p
    mv ${APACHE_DIR}/apache-${httpd_version}/cgi-bin/* ${APACHE_DIR}/httpd-${httpd_version}/cgi-bin-backup/

    # 修改目录权限
    chown -R ${USER}:${GROUP} ${APACHE_DIR}

}

modify_file(){
    local num=$(egrep -n '<Directory "'${APACHE_DIR}/apache-${httpd_version}'/cgi-bin">' ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf -A 4 | grep -i Require | awk '{print $1}' | cut -d '-' -f1)
    sed -i "${num}s/^.*/    Order deny,allow/" ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf
    sed -i "${num} a\    Deny from all" ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    sed -i "s/^Listen 80/Listen ${apache_listen_port}/"  ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf


    local count=$(egrep -c "^ServerName" ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf)
    if [ ${count} -eq 0 ];then
        sed -i "/^#ServerName/a\ServerName ${apache_listen_ip}:${apache_listen_port}" ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf
    else
        sed -i "/^ServerName/s/^.*/ServerName ${apache_listen_ip}:${apache_listen_port}/" ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf
    fi

    sed -i "s/LogLevel warn/LogLevel notice/" ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    sed -i 's/CustomLog/#&/' ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf
    sed -i "/    #CustomLog/a\\${apache_customlog}"  ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf
    # sed -i 's@    CustomLog "logs/access_log" common@#&@' ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf
    # sed -i '/#    CustomLog/a\    CustomLog " '${apache_customlog}' '${apache_customlog_dir}' '${apache_customlog_time}' '${apache_customlog_time_utc}'" common' ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf
    # sed -i 's/^    CustomLog "/&|/' ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/' ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    sed -i "s/ScriptAlias/#&/" ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    echo "KeepAlive On" >> ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    echo "KeepAliveTimeout 15" >> ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    echo "TimeOut 10" >> ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    echo "TraceEnable Off" >> ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    echo "ServerTokens Prod" >> ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    echo "ServerSignature Off" >> ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf

    cat >> ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf << EOF
<IfModule mpm_worker_module>
    ServerLimit 16 
    ThreadLimit 100 
    StartServers 16 
    MaxClients 1600 
    MinSpareThreads 160 
    MaxSpareThreads 1600 
    ThreadsPerChild 100 
    MaxRequestsPerChild 0 
</IfModule>
EOF
}

# 启动apache服务
start(){
    su ${USER} -c "${APACHE_DIR}/apache-${httpd_version}/bin/apachectl -f ${APACHE_DIR}/apache-${httpd_version}/conf/httpd.conf"
}

main(){
    check_base_env;
    install;
    modify_file;
    start;
}

main

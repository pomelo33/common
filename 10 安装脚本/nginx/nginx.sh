#!/bin/bash
# 编译安装Nginx
#
VERSION=${1:-nginx-1.16.1}
PRODIR=${2:-/app/fdprd/nginx}
LOGDIR=${3:-/app/fdprd/logs}
APPDIR=${4:-/app/fdprd/app}
PREFIX=${5:-/app/fdprd/nginx/$VERSION}
WORKDIR=${6:-/opt}
GROUP=${7:-fdprd}
USER=${8:-fdprd}
USERPASSWD=${9:-123456}
CONFIGURE_PARAMS="--with-poll_module --with-threads --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module \
    --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module \
    --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module \
    --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module \
    --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_perl_module \
    --with-http_stub_status_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module \
    --with-stream_realip_module --with-stream_geoip_module --with-google_perftools_module --with-cpp_test_module \
    --with-compat --with-debug --with-pcre --with-pcre-jit"
    #--add-module=/app/fdprd/nginx/nginx-upstream-jvm-route-master"

# 创建用户和目录
adduser(){
    egrep "^${GROUP}" /etc/group >> /dev/null 2>&1
    if [ $? -ne 0 ];then
        groupadd -g 1601 ${GROUP}
    fi

    id ${USER} >> /dev/null 2>&1
    if [ $? -ne 0 ];then
        useradd -u 1601 -g ${GROUP} -d /app/fdprd/ -m ${USER}
        echo "${USERPASSWD}" | passwd ${USER} --stdin
    fi
}

makedir(){
    FILE=($PRODIR $LOGDIR $APPDIR)

    for var in ${FILE[@]}; do
        if [ -e $var ]; then
            echo "Directory already exists"
        else
            mkdir -p $var
            chown -R ${USER}:${GROUP} $var
        fi
    done

    chmod -R 775 ${PRODIR}
}


# 编译和安装nginx

install_nginx(){
    # 安装依赖包
    yum -y install gcc* openssl openssl-devel pcre pcre-devel autoconf gd-devel perl perl-devel perl-ExtUtils-Embed GeoIP-devel gperftools libjpeg* libpng* freetype* libxml2* zlib* glibc* glib2* bzip2* ncurses* curl* e2fsprogs* krb5* libidn-devel openssl* openldap* nss_ldap

    # 解压源码包
    cd ${WORKDIR}
    echo -n "Extracting:  ${VERSION} ...   "
    tar -zxf ${WORKDIR}/${VERSION}.tar.gz
    cd ${WORKDIR}/${VERSION}/
    echo -e "[\e[0;32mDONE\e[0m]"

    ./configure \
    --prefix=${PRODIR}/${VERSION} --sbin-path=${PRODIR}/${VERSION} \
    --conf-path=${PRODIR}/${VERSION}/nginx.conf --pid-path=${PRODIR}/${VERSION}/nginx.pid --lock-path=${PRODIR}/${VERSION}/nginx.lock \
    --error-log-path=${PRODIR}/${VERSION}/error.log --http-log-path=${PRODIR}/${VERSION}/access.log ${CONFIGURE_PARAMS}

    make && make install
}

start_nginx(){
    # 添加环境变量
    echo "export PATH=${PRODIR}/${VERSION}:$PATH" > /etc/profile.d/nginx.sh
    source /etc/profile.d/nginx.sh
    # 启动
    ${PRODIR}/${VERSION}/nginx -c ${PRODIR}/${VERSION}/nginx.conf
}

main(){
    echo "Adduser and make directory..."
    adduser
#    makedir
#    echo "Compiling and Installing..."
#    install_nginx
#    start_nginx
#    echo "Finished!"
}

main


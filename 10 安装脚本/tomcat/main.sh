#!/bin/bash
FILE=$1

# 检查是否存在jq
command -v  jq >> /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    yum install epel-release -y
    yum install jq -y
    sleep 60
fi

VERSION=$(jq -r ".base.version" $FILE)
USER=$(jq -r ".base.tomcat_user" $FILE)
GROUP=$(jq -r ".base.tomcat_group" $FILE)
USERPASSWD=$(jq -r ".base.tomcat_user_pwd" $FILE)
TOMCAT_DIR=$(jq -r ".base.tomcat_dir" $FILE)
TOMCAT_PACKAGE=$(jq -r ".base.tomcat_package" $FILE)
JAVA_HOME=$(jq -r ".jvm.java_home" $FILE)

#setenv参数
setenv_home=$(jq -r ".jvm.java_home" $FILE)
setenv_currentuser=$(jq -r ".jvm.currentuser" $FILE)
setenv_log_path=$(jq ".jvm.log_path" $FILE)
setenv_log_options=$(jq ".jvm.log_options" $FILE)
setenv_LOG_OPTIONS=$(jq ".jvm.LOG_OPTIONS" $FILE)
setenv_java_opts=$(jq ".jvm.java_opts" $FILE)
setenv_app_options=$(jq ".jvm.app_options" $FILE)
setenv_catalina_opts=$(jq ".jvm.CATALINA_OPTS" $FILE)



field_check(){
    local keyword=$1
    local content=$2
    if [ -n "${content}" ];then
        echo "${keyword}=${content}" >> ${TOMCAT_DIR}/bin/setenv.sh
    fi
}

#检查java环境
check_java_home(){
    if [ -z ${JAVA_HOME} ];then
        echo "Not found JAVA_HOME!"
    else
        echo "JAVA_HOME found: ${JAVA_HOME}"
        if [ ! -e ${JAVA_HOME} ];then
            echo "Invalid JAVA_HOME. Make sure your JAVA_HOME path exists"
            exit 1
        fi
    fi
}

#检查用户及目录是否创建#
check(){
    egrep "^${GROUP}" /etc/group >& /dev/null 
    if [ $? -ne 0 ];then
        groupadd -g 500 ${GROUP}
    fi

    id ${USER} >& /dev/null 
    if [ $? -ne 0 ];then
        useradd -u 500 -g ${GROUP} -d ${TOMCAT_DIR} -m ${USER}
        echo "${USERPASSWD}" | passwd ${USER} --stdin
    fi

    if [ ! -d ${TOMCAT_DIR} ];then
        mkdir -p ${TOMCAT_DIR}    
    fi
}

# 安装
install(){
    if [ -e apache-tomcat-${VERSION}.tar.gz ];then
        tar -xf apache-tomcat-${VERSION}.tar.gz 
        mv apache-tomcat-${VERSION}/* ${TOMCAT_DIR}/
        chown -R ${USER}:${GROUP} ${TOMCAT_DIR}
        chmod 755 ${TOMCAT_DIR}
    else
        echo "FILE IS NOT Existent"
    fi
    cd ${TOMCAT_DIR}/ && mv webapps webappsbakcup && mkdir webapps && chown -R ${USER}:${GROUP} webapps
    echo "#!/bin/sh" >>${TOMCAT_DIR}/bin/setenv.sh
    echo "##config tomcat startup environment"  >>${TOMCAT_DIR}/bin/setenv.sh
    echo "#add by sucheng, for config tomcat"  >>${TOMCAT_DIR}/bin/setenv.sh
    field_check "JAVA_HOME" "${setenv_home}"
    field_check "CURRENTUSER" "${setenv_currentuser}"
    echo 'CATALINA_PID=$CATALINA_BASE/tomcat.pid' >>${TOMCAT_DIR}/bin/setenv.sh 
    field_check "LOG_PATH" "${setenv_log_path}"
    field_check "LOG_OPTIONS" "${setenv_log_options}"
    field_check "LOG_OPTIONS" "${setenv_LOG_OPTIONS}"
    field_check "JAVA_OPTS" "${setenv_java_opts}"
    field_check "APP_OPTIONS" "${setenv_app_options}"
    echo 'JAVA_OPTS=$JAVA_OPTS $APP_OPTIONS' >>${TOMCAT_DIR}/bin/setenv.sh
    echo 'CATALINA_OUT=$LOG_PATH/catalina.out' >>${TOMCAT_DIR}/bin/setenv.sh
    field_check "CATALINA_OPTS" "${setenv_CATALINA_OPTS}"
    echo 'CATALINA_OPTS=$CATALINA_OPTS $LOG_OPTIONS'  >>${TOMCAT_DIR}/bin/setenv.sh
    chown ${USER}:${GROUP} ${TOMCAT_DIR}/bin/setenv.sh
    chmod +x ${TOMCAT_DIR}/bin/setenv.sh
}

# 启动tomcat
start(){
    su  ${USER} -c "${TOMCAT_DIR}/bin/startup.sh"
}

main(){
    check_java_home;
    check;
    install;
    start;
}

main

#!/bin/bash
# 变量为读取json文件内容
FILE=$1
# 检查是否存在jq
command -v  jq >> /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    yum install epel-release -y
    yum install jq -y
    sleep 60
fi

# 获取基本信息
user=$(jq -r ".user" $FILE)
java_version=$(jq -r ".java.version" $FILE)
package_version=$(jq -r ".package.version" $FILE)
java_basedir=$(jq -r ".basedir" $FILE)
java_default_version=$(java -version 2>&1 | sed '1!d' | sed -e 's/"//g' | awk '{print $3}')

# 检查jdk版本是否符合安装版本
jdk_check(){
    if [ ${java_version} == ${java_default_version} ];then
        echo "JAVA IS Existence"
    else
        jdk_install
    fi
}

jdk_install(){
    # 判断安装目录是否存在，不存在则创建
    [[ ! -d ${java_basedir} ]]  && mkdir ${java_basedir}
    # 解压jdk安装包
    tar -xf jdk-${package_version}-linux-x64.tar.gz -C ${java_basedir}
    # 查看当前用户的环境变量是否存在
    local count=$(su ${user} -c "egrep -c 'JAVA_HOME' ~/.bash_profile")
    if [ ${count} -eq 0 ];then
        su  ${user} <<EOF
echo 'export JAVA_HOME=${java_basedir}/jdk${java_version}' >>  ~/.bash_profile
echo 'export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib/tools.jar' >> ~/.bash_profile
echo 'export JRE_HOME=\$JAVA_HOME/jre' >>  ~/.bash_profile
echo 'export PATH=\$JAVA_HOME/bin:\$PATH' >>  ~/.bash_profile
EOF
    su - ${user} -c "source ~/.bash_profile"
    fi
    chown -R root:root ${java_basedir}
    chmod -R 755 ${java_basedir}
    java -version >> /dev/null 2>&1
    if [ "$?" -eq 0 ];then
        echo "@###############################################@"
        echo "success: true"
        echo "message: jdk  deploied sccuessed"
        echo "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#"
    else
        echo "@###############################################@"
        echo "success: false"
        echo "message: jdk  depoloied faild"
        echo "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#"
    fi
}

main(){
    jdk_check;
}
main

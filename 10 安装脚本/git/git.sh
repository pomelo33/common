#!/usr/bin/env bash
CMD=$(command -v wget > /dev/null 2>&1)

check(){
    # 检查系统是否为centos或者redhat
    if egrep -qi "CentOS" /etc/issue || egrep -q "CentOS" /etc/*-release;then
        echo "This is Centos system!!!"
        git_install

    elif  grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release;then
        echo "This is Red Hat system!!!"
    git_install

    else
        echo "THis is Ubuntu!!!"
    fi
}

git_install(){
    # 判断系统版本
    RELEASEVER=$(rpm --eval %rhel)
    if [[ ${RELEASEVER} -ne 6 ]] && [[ ${RELEASEVER} -ne 7 ]];then
        echo "unsupported OS version"
        exit 1
    fi
    # 下载源
    wget -O /etc/yum.repos.d/ius.repo https://repo.ius.io/ius-${RELEASEVER}.repo
    sudo yum install -y git222

    # 查看版本
    VERSION=$(git --version | awk '{print $3}')
    echo "git版本为:${VERSION}"   
}

# 判断用户为root用户
if [[ ${UID} -ne 0 ]];then
    echo "This is script requires root privileges" >&2
    exit 1
else
    if [ ${CMD} -ne 0 ];then
        yum install -y wget
        check
    else
        check
    fi
fi
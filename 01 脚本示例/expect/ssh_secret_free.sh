#!/usr/bin/env bash
# ip.txt文件样例
# x.x.x.x user password

# 生成密钥对
setup_key(){
    # 判断${HOME}/.ssh/id_rsa文件是否存在
    if [ ! -f "${HOME}/.ssh/id_rsa" ];then
        echo "Generate RSA key pairs, please press ENTER for all questions."
        ssh-keygen -q -f ${HOME}/.ssh/id_rsa -t rsa -N "" 
    fi
    authorized_key=`cat $HOME/.ssh/id_rsa.pub`
}

# 批量推送推送公钥文件
push_remote(){
    while read line;do
        IPADDRESS=$(echo ${line} |cut -d ' ' -f 1)
        USER=$(echo ${line} | cut -d ' ' -f 2)
        PASSWORD=$(echo ${line} | cut -d ' ' -f 3)
        echo "Start to collect the public key fingerprint of the target machine."
        #  收集目标服务器的公钥指纹
        ssh-keyscan ${IPADDRESS} >> ${HOME}/.ssh/known_hosts
        #  将公钥推送到目标服务器
        expect <<EOF
            spawn ssh-copy-id -i ${HOME}/.ssh/id_rsa ${USER}@${IPADDRESS}
            expect {
                "password" {send "${PASSWORD}\n"}
            }
            expect eof
EOF
    done < /tmp/ip.txt
}

main(){
    setup_key;
    push_remote;
}
main

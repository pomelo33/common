#!/usr/bin/env bash
IPADDR=$(ip a | grep "inet " | grep -v '127.0.0.1' | awk -F ' ' '{print $2}' | cut -d '/' -f1)
cat >  /etc/yum.repos.d/zabbix.repo<<EOF
[zabbix]
name=Zabbix Official Repository - \$basearch
baseurl=http://repo.zabbix.com/zabbix/5.0/rhel/7/\$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

[zabbix-frontend]
name=Zabbix Official Repository frontend - \$basearch
baseurl=http://repo.zabbix.com/zabbix/5.0/rhel/7/\$basearch/frontend
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

[zabbix-debuginfo]
name=Zabbix Official Repository debuginfo - \$basearch
baseurl=http://repo.zabbix.com/zabbix/5.0/rhel/7/\$basearch/debuginfo/
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
gpgcheck=0

[zabbix-non-supported]
name=Zabbix Official Repository non-supported - \$basearch
baseurl=http://repo.zabbix.com/non-supported/rhel/7/\$basearch/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
gpgcheck=0
EOF
yum clean all
yum makecache
yum install -y zabbix-agent2
cp /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf.default
cat > /etc/zabbix/zabbix_agent2.conf <<EOF
PidFile=/var/run/zabbix/zabbix_agent2.pid
LogFile=/var/log/zabbix/zabbix_agent2.log
LogFileSize=3
Server=x.x.x.x
ServerActive=x.x.x.x
Hostname=${IPADDR}
HostMetadataItem=system.uname
Include=/etc/zabbix/zabbix_agent2.d/*.conf
ControlSocket=/tmp/agent.sock
EOF
systemctl enable zabbix-agent2
systemctl start zabbix-agent2

### vCenter相关脚本
| 版本号 | 更新时间 | 更新内容     |
| ------ | -------- | ------------ |
| 1.0    | 2021.05  | 上传脚本     |
| 1.1    | 2021.08  | 更新文档说明 |
|        |          |              |

#### example.csv
表格描述: 脚本执行调用csv文件格式(根据具体场景修改对应列名)

##### install_vcenter.ps1
脚本描述: vCenter批量创建虚拟机

##### addvlan.ps1
脚本描述： vCenter批量添加vlan

##### increase_cpu.ps1
脚本描述: vCenter虚拟机CPU扩容

##### increase_mem.ps1
脚本描述：vCenter虚拟机内存扩容

##### vcenter_diskExpansion.ps1
脚本描述: vCenter虚拟机磁盘扩容

##### move_vcDatastore.ps1
脚本描述: vCenter虚拟机迁移(数据迁移)

##### vcenter_transferVirtual.ps1
脚本描述: vCenter虚拟机迁移(宿主机迁移)

##### vcenter_clone.ps1
脚本描述: vCenter虚拟机克隆

##### vcenter_vmSwitchAddport.ps1
脚本描述: vCenter Vlan添加端口

#### 脚本运行样例
```
install_vcenter.ps1 example.csv
```

##### collect_info.ps1
脚本描述：vCenter部分采集信息数据格式化


##### collect_Cluster.ps1
脚本描述：获取集群信息

##### collec_datastore.ps1
脚本描述：获取数据存储信息
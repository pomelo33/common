###### vm宿主机信息收集
# 导入powershellC模块
# Import-Module -Name "Initialize-PowerCLIEnvironment.ps1" | Out-Null
# Out-Null 忽略提示信息
Import-Module -Name <PowerCLI路径> | Out-Null
Import-Module Microsoft.PowerShell.Utility | Out-Null

# 连接vmware 
Connect-VIServer <vCenterIP地址> -Username <用户名> -Password <密码> | Out-Null

# 查看vm宿主机信息
# $info = Get-Vmhost

# 定义空字符串
$collect_info=""

# 查询vm宿主机的Name信息
# 使用select参数，仅显示Name列对应的数据
$vmhostinfo = (Get-Vmhost | select).Name
# 查询vm宿主机对应的版本号
$versioninfo = (Get-Vmhost | select).Version
# 查询vm宿主机cpu个数
$numcpu = (Get-Vmhost | select).NumCpu
# 查询vm宿主机cpu
$cputotal = (Get-Vmhost | select).CpuTotalMhz
# 查询vm宿主机总内存
$memtotal = (Get-Vmhost | select).MemoryTotalGB


# for循环进行格式化数据
# $hostinfo.count：统计数据行数，类似linux的wc -l命令
for ($i=1;$i -lt $vmhostinfo.Count; $i++) {
    # 获取宿主机对应的集群
    $parent = (Get-Vmhost -name $hostinfo[$i] | select -ExpandProperty "Parent" | select ).Name
    # 格式化浮点数
    $mem_int = [math]::round($memtotal[$i],0)
    # 根据下标去对应的数据值
    $collect_info += "name:" + $vmhostinfo[$i] + ",version:" + $versioninfo[$i] + ",numcpu:" + $numcpu[$i] + ",totalcpu:" + $cputotal[$i] + ",totalmem:" + $memtotal[$i]
}

# 输出采集后的数据
echo -n $collect_info.Trim(" .-`t`n`r")


######## vm集群信息收集
# Get-Cluster | Get-Member  # 查询属性值
# eg: (Get-Cluster -Name xxx).Name
#
# 查询vm集群信息
$cluster = $(Get-Cluster |select).Name

####### vm虚机信息收集
$hostinfo = $(Get-VM | select).Name
# 获取vm name虚机主机名和IP地址
#Get-VM | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}

# 导入模块powerCLI模块
# Import-Module -Name "Initialize-PowerCLIEnvironment.ps1"
Import-Module -Name <PowerCLI路径>
Import-Module Microsoft.PowerShell.Utility

Write-Host -ForegroundColor Blue "start!"
Connect-VIServer <vCenterIP地址> -Username <用户名> -Password <密码>
$VMsList=Import-Csv $args[0] -Encoding Default
foreach($vms in $VMsList)
{
# 主机名
$vmHost=$vms.ost
# 扩容大小
$vmSize=$vms.ize
# 数据磁盘
$vmDatastore=$vms.atastore

New-HardDisk -VM  $vmHost  -CapacityGB $vmSize  -Datastore $vmDatastore  -Persistence persistent -DiskType flat -StorageFormat "Thin" -Confirm:$false
}
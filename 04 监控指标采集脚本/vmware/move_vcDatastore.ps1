# Import-Module -Name "Initialize-PowerCLIEnvironment.ps1"
Import-Module -Name <PowerCLI路径>
Import-Module Microsoft.PowerShell.Utility

Write-Host -ForegroundColor Blue "start!"
# 连接vc
Connect-VIServer <vCenterIP地址> -Username <用户名> -Password <密码>
# 导入 CSV
$vmsList=Import-Csv $args[0] -Encoding Default
foreach($vms in $vmsList)
{
$vmName=$vms.ame
$vmDatastore=$vms.atastore
move-Vm $vmName -Datastore $vmDatastore -DiskStorageFormat "Thin" -Confirm:$false
}
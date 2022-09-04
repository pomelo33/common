# Import-Module -Name "Initialize-PowerCLIEnvironment.ps1"
Import-Module -Name <PowerCLI路径>
Import-Module Microsoft.PowerShell.Utility

Write-Host -ForegroundColor Blue "start!"
# 连接vc
Connect-VIServer <vCenterIP地址> -Username <用户名> -Password <密码>
$vms=Import-Csv $args[0] -Encoding Default
foreach($vm in $vms)
{
Get-VM -Name $vm.Name | Move-VM -Destination $vm.Host
} 
# Import-Module -Name "Initialize-PowerCLIEnvironment.ps1"
Import-Module -Name <PowerCLI路径>
Import-Module Microsoft.PowerShell.Utility
Write-Host -ForegroundColor Blue "start!"

# 连接vc
Connect-VIServer <vCenterIP地址> -Username <用户名> -Password <密码>

# 加载虚拟机清单
$VMsList=Import-Csv $args[0] -Encoding Default
foreach($vms in $VMsList)
{
$vmHost=$vms.ost
$vmSwitch=$vms.witch
$vmSwitchport=$vms.witchport
$vmVlanid=$vms.lanid

# add port
Get-VirtualSwitch -VMHost $vmHost -Name $vmSwitch |New-VirtualPortGroup  -Name $vmSwitchport -vlanid $vmVlanid

#修改为所需网络标签，且设置网卡打开电源时连接
#Get-VM $newvmName | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $vmNetworkName -StartConnected:$true -Confirm:$false
}
# Import-Module -Name "Initialize-PowerCLIEnvironment.ps1"
Import-Module -Name <PowerCLI路径>
Import-Module Microsoft.PowerShell.Utility

Connect-VIServer <vCenterIP地址> -Username <用户名> -Password <密码>
Foreach ($vmhost in (get-cluster -name "<集群名称>" | get-vmhost))
{
$vs = Get-VirtualSwitch -VMHost $vmHost -Name "<vlan名称>"
$vlan = New-VirtualPortGroup -VirtualSwitch $vs -Name "<IP段>" -vlanid <Number>
}

# description： 通过模板批量创建虚拟机
# Import-Module -Name "Initialize-PowerCLIEnvironment.ps1"
Import-Module -Name <PowerCLI路径>
Import-Module Microsoft.PowerShell.Utility

Write-Host -ForegroundColor Blue "start!"
#sleep -s (1*4)
$vc="x.x.x.x" # vCenter IP                                            #vCenter IP地址
connect-viserver -server $vc                                               #链接VC，输入ID/PW
$VMsList=Import-Csv <csv文件清单> -Encoding Default       #加载虚拟机清单
$custsysprep = Get-OSCustomizationSpec "Linux"
foreach($vms in $VMsList)
{
$vmName=$vms.ame                                                           #虚拟机名称
$vmDatastore=$vms.atastore                                                 #创建虚拟机目标存储
$vmHost=$vms.ost                                                           #创建虚拟机目标主机
$vmTemplate=$vms.emplate                                                   #模板名称
$vmIP=$vms.P                                                               #虚拟机IP
$vmMask=$vms.ask                                                           #虚拟机NETMASK
$vmGateway=$vms.ateway                                                     #虚拟机GATEWAY
$vmNote=$vms.ote                                                           #虚拟机备注
$vmCpu=$vms.pu                                                             #虚拟机CPU
$vmMemory=$vms.emory                                                       #虚拟机内存
$vmDisk=$vms.isk                                                           #虚拟机添加磁盘大小
$vmHarddatastore=$vms.arddatastore                                         #虚拟机新增磁盘目标存储
$vmNetworkName=$vms.etworkname                                             #端口组名称
$Location=$vms.ocation                                                     #虚拟机所在文件夹

$custsysprep | Set-OScustomizationSpec -NamingScheme fixed -NamingPrefix $vmName |Out-Null 
$custsysprep | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $vmIP -SubnetMask $vmMask  -DefaultGateway $vmGateway  |Out-Null
$Note = $vmNote + $vmName + ":" + $vmIP
$ds1=get-datastore -name $vmDatastore
#通过模板部署虚拟机
New-vm -vmhost $vmHost -Name $vmName -Template $vmTemplate -StorageFormat "Thin" -Datastore $vmDatastore -OSCustomizationspec $custsysprep  -Location $Location -Notes $Note -Confirm:$false
#Write-Host "已将虚拟机存储迁移到" $vmDatastore
$hello = "VM: " + $vmName +" IP: " + $vmIP  + " is Created on ESXi: " + $vmHost + " and datastore: " + $vmDatastore
Write-Host -ForegroundColor Blue $hello  $vmNote

#配置vCPU ，内存 

Get-VM $vmName | Set-VM -NumCpu $vmCpu -MemoryGB $vmMemory -Confirm:$false
#添加磁盘
if ( $vmDisk -eq "" -or $vmDisk -eq 0)
{
}
else
{
    Get-VM $vmName | New-HardDisk -CapacityGB $vmDisk -Persistence persistent -DiskType Flat -StorageFormat Thin -Confirm:$false
}
#修改为所需网络标签，且设置网卡打开电源时连接
Get-VM $vmName | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $vmNetworkName -StartConnected:$true -Confirm:$false
#开机
#Start-VM $vmName -Confirm:$false
#定时1分钟
sleep -s (10*1)
}
# 获取Vmhost及其网络信息
# To list all ESX Hosts and their Service console information

Get-VMHost | Get-VMHostNetwork | Select Hostname, ConsoleGateway, DNSAddress -ExpandProperty ConsoleNic | Select Hostname, PortGroupName, IP, SubnetMask, ConsoleGateway, DNSAddress, Devicename

# To list all ESX Hosts and their VMotion Enabled Networks :
Get-VMHost | Get-VMHostNetwork | Select Hostname, VMkernelGateway -ExpandProperty VirtualNic | Where {$_.VMotionEnabled} | Select Hostname, PortGroupName, IP, SubnetMask, VMkernelGateway, Devicename

# 获取vmname,vmid,ESXHOST,ESXIP,cluster,datastore
# 如果不考虑性能的话，下面这个脚本比较简单易懂,但速度慢
onnect-VIServer -server x.x.x.x -user administrator@vsphere.local -password 密码
Get-VM | Select Name,id, `
@{N="ESXIP";E={Get-VMHost -VM $_| Select ($_.ExtensionData.Config.Network.Vnic | ? {$_.Device -eq "vmk0"}).Spec.Ip.IpAddress}},`
@{N="ESXHOST";E={(Get-VMHost -VM $_).name}}, `
@{N="Cluster";E={Get-Cluster -VM $_}}, `
@{N="Datastore";E={Get-Datastore -VM $_}},`
Time | Export-Csv -NoTypeInformation c:\VMInfo\"33Export67VMinfo$(Get-Date -Format ‘yyyyMMdd‘).csv"
Disconnect-VIServer -server * -force  -Confirm:$false


# 考虑性能，尽量使用属性的方式获取
Connect-VIServer -server x.x.x.x -user administrator@vsphere.local -password 密码
Get-VM | Select Name,id, `
@{Name=’ESXIP’;Expression={%{$_.VMHost} | Select ($_.ExtensionData.Config.Network.Vnic | ? {$_.Device -eq "vmk0"}).Spec.Ip.IpAddress}},`
vmhost, `
@{Name=’Cluster’;Expression={$_.VMHost.Parent}}, `
@{"Name"="Datastore"; expression={($_.DatastoreIDList | %{(Get-View -Property Name -Id $_).Name}) -join ", "}},`
Time | Export-Csv -NoTypeInformation c:\VMInfo\"44Export67VMinfo$(Get-Date -Format ‘yyyyMMdd‘).csv"
Disconnect-VIServer -server * -force  -Confirm:$false


# 添加了硬盘对应的datastore的信息，因为有些机器不同硬盘所属datastore不同
Connect-VIServer -server x.x.x.x -user administrator@vsphere.local -password P@ssw0rd
Get-VM | Select Name,id, `
@{Name=’ESXIP’;Expression={%{$_.VMHost} | Select ($_.ExtensionData.Config.Network.Vnic | ? {$_.Device -eq "vmk0"}).Spec.Ip.IpAddress}},`
vmhost, `
@{Name=’Cluster’;Expression={$_.VMHost.Parent}}, `
@{N="Storage";E={(Get-HardDisk -VM $_ |Select @{N=‘HD‘;E={$_.Name}},@{N=‘Datastore‘;E={`
 ($_.Filename.Split(‘]‘)[0]).TrimStart(‘[‘)}}) -replace "@{HD=","" -replace "; Datastore","" -replace "}","" -replace "{","" `
 }},`
 Time | Export-Csv -NoTypeInformation -encoding utf8 c:\VMInfo\"Export67VMinfo$(Get-Date -Format ‘yyyyMMdd‘).csv" 
Disconnect-VIServer -server * -force  -Confirm:$false

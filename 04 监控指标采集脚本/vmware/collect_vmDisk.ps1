# 获取vm 磁盘 和磁盘对应的datastore的信息
# 针对一台虚机有多个磁盘，但每个磁盘可能所属datastore不同，所以需要列出来查看
Get-VM | %{
    $_.HardDisks | Select @{N="VM";E={$_.Parent.Name}},
        Name,
        @{N="DS";E={$_.Filename.Split(‘]‘)[0].TrimStart(‘[‘)}}
}

# 分着取可以直接转换为
$targetVM = Get-VM -Name "vmname"
$disks = Get-HardDisk $targetVM
$diskDatastore = $disks.Filename.Split(‘]‘)[0].TrimStart(‘[‘)

## 获取vm,cpu,memory,guest,vmdk,datastore信息，并保存为HTML文档
$a = "<title>$name</title>"
$a = $a +"<style>"
$a = $a + "BODY{background-color:blue;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
$a = $a + "</style>"
 
foreach($cluster in Get-Cluster){
    foreach($rp in Get-ResourcePool -Location $cluster){
        $report = foreach($vm in (Get-VM -Location $rp)){
            Get-HardDisk -VM $vm |
            Select @{N=‘Cluster‘;E={$cluster.Name}},
                @{N=‘ResourcePool‘;E={$rp.Name}},
                @{N=‘VM‘;E={$vm.Name}},
                @{N=‘HD‘;E={$_.Name}},
                @{N=‘Datastore‘;E={($_.Filename.Split(‘]‘)[0]).TrimStart(‘[‘)}},
                @{N=‘Filename‘;E={($_.Filename.Split(‘ ‘)[1]).Split(‘/‘)[0]}},
                @{N=‘VMDK Path‘;E={$_.Filename}},
                @{N=‘Format‘;E={$_.StorageFormat}},
                @{N=‘Type‘;E={$_.DiskType}},
                @{N=‘CapacityGB‘;E={$_.CapacityGB}}
        }
        $report | ConvertTo-Html -Head $a | Out-File -FilePath "C:\temp\$($cluster.Name)-$($rp.Name)-report.html"
    }
}

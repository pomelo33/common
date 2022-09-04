Import-Module -Name "$path:\Initialize-PowerCLIEnvironment.ps1"
Import-Module Microsoft.PowerShell.Utility 
$connection=Connect-VIServer x.x.x.x -Username administrator@xxxx.xxxx -Password xxxxxx | Out-Null
$a = ""
$b = (Get-Vmhost | select ).Name
$c = (Get-Vmhost | select ).Version
$d = (Get-Vmhost | select).NumCpu
$e = (Get-Vmhost | select).CpuTotalMhz
$f = (Get-Vmhost | select).MemoryTotalGB

for($i=0;$i -lt $b.count;$i++) {
    $g = (Get-Vmhost -name $b[$i] | select -ExpandProperty "Parent" | select).Name
    $h = [math]::round($f[$i],0)
    $a += "name:" + $b[$i] + ",version:" +  $c[$i] + ",totalmem:" + $h + ",uuid:" +  $b[$i] + ",ip:" + $b[$i] + ",newcpu:" +$d[$i] +  ",totalcpu:" + $e[$i] + ",parent:" + $g + "@@@@"
}
echo -n "$a"

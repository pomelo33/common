Import-Module -Name "$path:\Initialize-PowerCLIEnvironment.ps1"
Import-Module Microsoft.PowerShell.Utility 
$connection=Connect-VIServer x.x.x.x -Username administrator@xxx.xxxx -Password x.x.x.x | Out-Null
$a = ""
$b = (Get-VM | select ).Name
$c = (Get-VM | select Name,@{N="IPAddress";E={@($_.Guest.IPAddress[0])}} |select).IPAddress
$e = ((Get-VM | select Name,VMHost | select).VMHost | select).Name
$x = (Get-VM | select).NumCpu
$y = (Get-VM | select).MemoryMB
for($i=0;$i -lt $b.count;$i++) {
If([String]::IsNullOrEmpty($c[$i]))
{
$d="null"
}
Else {
$a += "name:" + $b[$i] + ",service_ip:" + $c[$i] + ",uuid:" + $c[$i] +  ",vmhost:" + $e[$i]  + ",cpu_cores:" + $x[$i] + ",memory_capacity:" + $y[$i] + "MB,type:Y@@@@"
}
}
echo -n "$a"

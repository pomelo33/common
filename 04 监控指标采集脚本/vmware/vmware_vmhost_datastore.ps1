Import-Module -Name "$path:\Initialize-PowerCLIEnvironment.ps1"
Import-Module Microsoft.PowerShell.Utility 
$connection=Connect-VIServer x.x.x.x -Username administrator@xxxx.xxxx -Password xxxxx | Out-Null
$a = ""
$b = (Get-VMHost).Name
for($i=0;$i -lt $b.count;$i++) {
    $c = (Get-datastore -vm $b[$i]).Name
	$d = ""
	for ($x=0;$x -lt $c.count;$x++){
        $d += $c[$x] + "++++"
}
    $a += "vmhosts:" + $b[$i] + ",datastore:" +  $d + "@@@@"
}
echo -n "$a"

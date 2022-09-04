Import-Module -Name "$path:\Initialize-PowerCLIEnvironment.ps1"
Import-Module Microsoft.PowerShell.Utility 
$connection=Connect-VIServer x.x.x.x -Username administrator@xxxx.xxxx -Password xxxxxx | Out-Null
$a = ""
$b = (Get-Cluster | select).Name
for($i=0;$i -lt $b.count;$i++) {
    $x = $b[$i]
    $c = (Get-VMHost | Where-Object {$_.Parent -like $x} | select).Name
    $d = ""
    for ($z=0;$z -lt $c.count;$z++){
        $d += $c[$z] + "_"
    }
    $a +=  "vmhosts:" + $d + ",uuid:" + $b[$i] + ",name:" + $b[$i] + "@@@@" 
}
echo -n "$a"

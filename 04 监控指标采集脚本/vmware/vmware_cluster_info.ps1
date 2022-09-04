Import-Module -Name "$path:\Initialize-PowerCLIEnvironment.ps1"
Import-Module Microsoft.PowerShell.Utility 
$connection=Connect-VIServer x.x.x.x  -Username administrator@xxx.xxx -Password xxxxx| Out-Null
$a = ""
$b = (Get-Cluster | select ).Name

for($i=0;$i -lt $b.count;$i++) {
    $a += "name:" + $b[$i] + ",uuid:" +  $b[$i] + "@@@@"
}
echo -n "$a"

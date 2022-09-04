# 通过一条命令，获取Host, Cluster and Datastore Details
# 具体可以看这位的参考Host, Cluster and Datastore Details

# Is there any way to use autosize, as the long datastore names trunctes.
# Try Autosize

Get-VM (Get-content c:\temp\vms.txt) | Select-Object -Property @{Name=‘VMName‘;Expression={$_.Name}},VMHost,@{Name=‘ClusterName‘;Expression={$_.VMHost.Parent}}, @{"Name"="Datastore"; expression={($_.DatastoreIDList | %{(Get-View -Property Name -Id $_).Name}) -join ", "}} | FT -AutoSize


# Try wrapping?
Get-VM (Get-content c:\temp\vms.txt) | Select-Object -Property @{Name=‘VMName‘;Expression={$_.Name}},VMHost,@{Name=‘ClusterName‘;Expression={$_.VMHost.Parent}}, @{"Name"="Datastore"; expression={($_.DatastoreIDList | %{(Get-View -Property Name -Id $_).Name}) -join ", "}} | FT -Wrap
 

# If possible, can we use sort-object with VM Names ?
# Yep, just pipe to Sort-Object

Get-VM (Get-content c:\temp\vms.txt) | Select-Object -Property @{Name=‘VMName‘;Expression={$_.Name}},VMHost,@{Name=‘ClusterName‘;Expression={$_.VMHost.Parent}}, @{"Name"="Datastore"; expression={($_.DatastoreIDList | %{(Get-View -Property Name -Id $_).Name}) -join ", "}} | Sort VMName

# Also, can we use export-csv to export the out put to excel ?
# Yep, Just pipe to Export-CSV

Get-VM (Get-content c:\temp\vms.txt) | Select-Object -Property @{Name=‘VMName‘;Expression={$_.Name}},VMHost,@{Name=‘ClusterName‘;Expression={$_.VMHost.Parent}}, @{"Name"="Datastore"; expression={($_.DatastoreIDList | %{(Get-View -Property Name -Id $_).Name}) -join ", "}} | Export-CSV -NoTypeInformation C:\temp\VMExport.csv

import sys
readDomain("/app/fdprd/app/base_domain/user_project")
cd("/")
create("mycluster","Cluster")
create("server1","Server")
assign("Server","myserver1,myserve2","Cluster","mycluster")
writeDomain('/app/fdprd/app/base_domain/user_project')
updateDomain()
closeDomain()
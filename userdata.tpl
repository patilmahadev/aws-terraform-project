#!/bin/bash

############## Install Apache Web Server ##############
yum install httpd -y
service httpd start

echo "
<html>
<title>remoteX</title>
<h2>
Web Server Launch Time: $(date)<br>
</h2>
<h3>
For more information please visit <a href="https://www.remotex.io">https://www.remotex.io</a>
</h3>
</html>
" > /var/www/html/index.html

################## Mount EFS target ##################
yum install nfs-utils -y
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/ /mnt
echo "${efs_dns_name}:/ /mnt nfs4 defaults,_netdev 0 0" >> /etc/fstab
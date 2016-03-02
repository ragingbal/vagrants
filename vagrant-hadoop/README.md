Bog standard Ubuntu Trusty with a script to install hadoop and hive.


Before you run please check the setup.sh script which sets things up. You have 2 options
* Use an internal mirror
* Use an external mirror

The function list is at the end of the file. For internal use downloadInternalPackages and for external use downloadExternalPackages


In order to get things working
* vagrant up
* vagrant ssh
* cp -r /vagrant/configs ~/
* cp /vagrant/setup.sh ~/
* chmod +x setup.sh
* sudo ./setup.sh
* exit

Download of all needed files is from our local network(FTP), so it`ll work only in office..

on local machine
All services run on 192.168.43.43:port
DataNode on 192.168.43.43:50075
NameNode WebUI on 192.168.43.43:50070

Hive CLI
vagrant ssh and just type hive

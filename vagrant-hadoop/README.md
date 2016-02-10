Bog standard Ubuntu Trusty with a script to install hadoop and hive.


In order to get things working
vagrant up
vagrant ssh
cp -r /vagrant/configs ~/
cp /vagrant/setup.sh ~/
chmod +x setup.sh
./setup.sh

Am not using bootstrapping the images since the downloads often fail. You can comment out the download step in the script if all downloads are completed and yo u wish to makes ome changes to the install script.





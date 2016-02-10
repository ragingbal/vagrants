#!/bin/bash
export JAVA_HOME=/usr/local/java
export HADOOP_PREFIX=/usr/local/hadoop
export HIVE_HOME=/usr/local/hive
HADOOP_ARCHIVE=hadoop-2.7.1.tar.gz
JAVA_ARCHIVE=jdk-7u51-linux-x64.tar.gz
MAHOUT_ARCHIVE=apache-mahout-distribution-0.11.1.tar.gz
HIVE_ARCHIVE=apache-hive-1.2.1-bin.tar.gz
HADOOP_MIRROR_DOWNLOAD=http://www.us.apache.org/dist/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz
HIVE_MIRROR_DOWNLOAD=http://www.eu.apache.org/dist/hive/stable/apache-hive-1.2.1-bin.tar.gz
PIG_MIRROR_DOWNLOAD=http://www.eu.apache.org/dist/pig/latest/pig-0.15.0.tar.gz
JAVA_MIRROR_DOWNLOAD=https://www.reucon.com/cdn/java/jdk-7u51-linux-x64.tar.gz
MAHOUT_MIRROR_DOWNLOAD=http://www.eu.apache.org/dist/mahout/0.11.1/apache-mahout-distribution-0.11.1.tar.gz

function downloadPackages {
	mkdir install_packages
	curl -O $HADOOP_MIRROR_DOWNLOAD 
	curl -O $HIVE_MIRROR_DOWNLOAD 
	curl -O $JAVA_MIRROR_DOWNLOAD 
	curl -O  $MAHOUT_MIRROR_DOWNLOAD
	mv $JAVA_ARCHIVE install_packages/
	mv $HADOOP_ARCHIVE install_packages/
	mv $HIVE_ARCHIVE install_packages/
	mv $MAHOUT_ARCHIVE install_packages/
}

function installLocalJava {
	echo "installing oracle jdk"
	FILE=~/install_packages/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/jdk1.7.0_51/ /usr/local/java
	echo export JAVA_HOME=/usr/local/java >> ~/.bashrc
}

function installLocalHadoop {
	echo "install hadoop from local file"
	FILE=~/install_packages/$HADOOP_ARCHIVE
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/hadoop-2.7.1/ /usr/local/hadoop
}

function installLocalMahout {
	echo "install hadoop from local file"
	FILE=~/install_packages/$MAHOUT_ARCHIVE
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/apache-mahout-distribution-0.11.1/ /usr/local/mahout
}

function installLocalHive {
	echo "install hive from local file"
	FILE=~/install_packages/$HIVE_ARCHIVE
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/apache-hive-1.2.1-bin/ /usr/local/hive
}

function setupHive {
	echo export HIVE_HOME=/usr/local/hive >> ~/.bashrc
	echo export PATH=\${HIVE_HOME}/bin:$PATH >> ~/.bashrc
}

function setupHadoop {
	echo "creating hadoop directories"
	mkdir /tmp/hadoop-namenode
	mkdir /tmp/hadoop-logs
	mkdir /tmp/hadoop-datanode
	ln -s /usr/local/hadoop-2.7.1 /usr/local/hadoop
	echo "copying over hadoop configuration files"
	cp -f ~/configs/core-site.xml /usr/local/hadoop/etc/hadoop
	cp -f ~/configs/hdfs-site.xml /usr/local/hadoop/etc/hadoop
	cp -f ~/configs/mapred-site.xml /usr/local/hadoop/etc/hadoop
	cp -f ~/configs/yarn-site.xml /usr/local/hadoop/etc/hadoop
	cp -f ~/configs/slaves /usr/local/hadoop/etc/hadoop
	cp -f ~/configs/hadoop-env.sh /usr/local/hadoop/etc/hadoop
	cp -f ~/configs/yarn-env.sh /usr/local/hadoop/etc/hadoop
	cp -f ~/configs/yarn-daemon.sh /usr/local/hadoop/sbin
	cp -f ~/configs/mr-jobhistory-daemon.sh /usr/local/hadoop/sbin
	echo "modifying permissions on local file system"
	chown -fR ubuntu /tmp/hadoop-namenode
	chown -fR ubuntu /tmp/hadoop-logs
    chown -fR ubuntu /tmp/hadoop-datanode
	mkdir /usr/local/hadoop-2.7.1/logs
	chown -fR ubuntu /usr/local/hadoop-2.7.1/logs
}

function setupHadoopService {
	echo "setting up hadoop service"
	cp -f ~/configs/hadoop /etc/init.d/hadoop
	chmod 777 /etc/init.d/hadoop
	#chkconfig --level 2345 hadoop on
}

function setupNameNode {
	echo "setting up namenode"
	/usr/local/hadoop-2.7.1/bin/hdfs namenode -format myhadoop
}


function addHost {

	echo 127.0.0.1 hadoop-yarn >> /etc/hosts
}

function startHadoopService {
	echo "starting hadoop service"
	service hadoop start
}

function initHdfsTempDir {
	$HADOOP_PREFIX/bin/hdfs --config $HADOOP_PREFIX/etc/hadoop dfs -mkdir /tmp
	$HADOOP_PREFIX/bin/hdfs --config $HADOOP_PREFIX/etc/hadoop dfs -chmod -R 777 /tmp
}

function updateProfile {

	echo export HADOOP_HOME=/usr/local/hadoop >> ~/.bashrc
	#cat configs/bash_configs.txt >> ~/.bashrc
	source ~/.bashrc

}

function installExtras {

	sudo apt-get install -y unzip
	sudo apt-get install -y git

}


downloadPackages
addHost
updateProfile
installLocalJava
installLocalHadoop
setupHadoopService
setupHadoop
setupNameNode
initHdfsTempDir
startHadoopService
installLocalHive
setupHive
#installLocalMahout

#HADOOP_PREFIX=/usr/local/hadoop
#JAVA_HOME=/usr/local/java
#export PATH=$PATH:/usr/local/hive








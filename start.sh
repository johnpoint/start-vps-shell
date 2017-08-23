#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin 

#check OS#
if [ -f /etc/redhat-release ];then 
 OS='CentOS' 
 elif [ ! -z "`cat /etc/issue | grep bian`" ];then 
 OS='Debian' 
 elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then 
 OS='Ubuntu' 
 else 
 echo "Not support OS, Please reinstall OS and retry!" 
 exit 1 
 fi 
 
#install#
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install curl wget unzip ntp ntpdate lrzsz git screen -y 
 else 
 apt-get update 
 apt-get install unzip ntp ntpdate lrzsz git screen -y 
 fi 

 #Set DNS #
 echo "nameserver 8.8.8.8" > /etc/resolv.conf 
 echo "nameserver 8.8.4.4" >> /etc/resolv.conf 
 
 #end
 echo 'END'
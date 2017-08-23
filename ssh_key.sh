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
 yum install openssl -y 
 else 
 apt-get update 
 apt-get install openssl -y 
 fi 

 #download key
 cd ~
 mkdir .ssh
 cd ~/.ssh
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/authorized_keys
 chmod 600 authorized_keys
 chmod 700 ~/.ssh

 #change sshconfig
 cd /etc/ssh
 rm -rf /etc/ssh/sshd_config
 wget -N --no-check-certificate https://github.com/johnpoint/start-vps-shell/blob/master/sshd_config
 
 #echo
 echo 'service sshd restart'
 echo 'END'


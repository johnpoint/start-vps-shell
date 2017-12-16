#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}
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
 
 
 echo '正在安装wget...'
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install wget -y 
 else 
 apt-get update 
 apt-get install wget -y 
 fi 
 echo '安装完成！'
 
 echo '正在获取脚本'
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh
chmod +x start.sh && ./start.sh
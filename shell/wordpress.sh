#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 1.2.1
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#=================================================

sh_ver="1.2.1"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}
#check OS#
if [ -f /etc/redhat-release ]; then
    release="centos"
    PM='yum'
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
fi
 #Install_lnmp
 Install_lnmp(){
 echo -e "${Tip} 正在安装wget"
 ${PM} update
 ${PM} install wget git -y 
 echo -e "${Tip} wget安装完成"
 echo -e "${Tip} 获取lnmp安装脚本"
 wget -c http://soft.vpser.net/lnmp/lnmp1.4.tar.gz && tar zxf lnmp1.4.tar.gz && cd lnmp1.4 && ./install.sh lnmp
 }
 #Add_vhost
 Add_vhost(){
 echo && stty erase '^H' && read -p "请输入命令：（add/del/list)" lnmp
 lnmp vhost $lnmp
 }
 #Install_wordpress
 Install_wordpress(){
 echo && stty erase '^H' && read -p "请输入您的域名：" yuming
 cd ~
 git clone https://github.com/WordPress/WordPress.git
 cd WordPress
 cp -rf * /home/wwwroot/$yuming
 cd ~
 rm -rf WordPress
 echo -e "${Info} done"
 }
 
	echo -e "  wordpress一键安装脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
 {Tip} 建议在screen环境中安装lnmp！ 
  ${Green_font_prefix}1.${Font_color_suffix} 安装 lnmp
  ${Green_font_prefix}2.${Font_color_suffix} 管理 虚拟主机
  ${Green_font_prefix}3.${Font_color_suffix} 安装 wordpress
  ————————————————
  ${Green_font_prefix}4.${Font_color_suffix} 一键安装
 "
	echo && stty erase '^H' && read -p "请输入数字 [1-3]：" num
case "$num" in
	1)
	Install_lnmp
	;;
	2)
	Add_vhost
	;;
	3)
	Install_wordpress
	;;
	4)
	Install_lnmp
	Add_vhost
	Install_wordpress
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-3]"
	;;
esac

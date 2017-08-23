#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 1.0.0
#	Author: johnpoint
#=================================================

sh_ver=1.0.1

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
 
 #Install_screen
 Install_screen(){
 echo '正在安装screen...'
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install screen -y 
 else 
 apt-get update 
 apt-get install screen -y 
 fi 
 echo '安装完成！'
 }
 #Install_lrzsz
 Install_lrzsz(){
 echo '正在安装lrzsz...'
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install lrzsz -y 
 else 
 apt-get update 
 apt-get install lrzsz -y 
 fi 
 echo '安装完成！'
 }
 #Install_git
 Install_git(){
 echo '正在安装git...'
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install git -y 
 else 
 apt-get update 
 apt-get install git -y 
 fi 
 echo '安装完成！'
 }
 #Install_ssr
 Install_ssr(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh && chmod +x ssrmu.sh && bash ssrmu.sh
 }
 #Install_status
 Install_status(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/status.sh && chmod +x status.sh
 bash status.sh s
 }
 #Install_v2ray
 Install_v2ray(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/v2ray.sh && chmod +x v2ray.sh && ./v2ray.sh
 }

 #Install_ytb_dl
 Install_ytb_dl(){
 cd ~
 wget https://yt-dl.org/downloads/2016.07.13/youtube-dl -O /usr/local/bin/youtube-dl
 chmod a+rx /usr/local/bin/youtube-dl
 echo && stty erase '^H' && read -p "请输入保存路径：" save
 cd $save
 echo && stty erase '^H' && read -p "请输入视频地址：" address
 youtube-dl $address
 }
 
#meun 
if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  常用软件一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 screen
  ${Green_font_prefix}2.${Font_color_suffix} 安装 lrzsz
  ${Green_font_prefix}3.${Font_color_suffix} 安装 git
  ${Green_font_prefix}4.${Font_color_suffix} 安装/管理 ssr
  ${Green_font_prefix}5.${Font_color_suffix} 安装/管理 逗逼监控
  ${Green_font_prefix}6.${Font_color_suffix} 安装 V2ray
  ${Green_font_prefix}7.${Font_color_suffix} 安装 Sync
  ${Green_font_prefix}8.${Font_color_suffix} 安装/使用 youtube-dl
 "
	echo && stty erase '^H' && read -p "请输入数字 [1-8]：" num
case "$num" in
	1)
	Install_screen
	;;
	2)
	Install_lrzsz
	;;
	3)
	Install_git
	;;
	4)
	Install_ssr
	;;
	5)
	Install_status
	;;
	6)
	Install_v2ray
	;;
	7)
	Install_sync
	;;
	8)
	Install_ytb_dl
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
esac
fi

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
 
#Install
Install(){
wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/install.sh && chmod install.sh && ./install.sh
}
#cg_passwd
cg_passwd(){
passwd
}
#menu
check_sys
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} !" && exit 1
action=$1
if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  VPS一键管理脚本 ${Red_font_prefix}
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 软件
  ${Green_font_prefix}2.${Font_color_suffix} 修改 密码
  ${Green_font_prefix}3.${Font_color_suffix} 
  ${Green_font_prefix}4.${Font_color_suffix} 
  ${Green_font_prefix}5.${Font_color_suffix} 
  ${Green_font_prefix}6.${Font_color_suffix} 
  ${Green_font_prefix}7.${Font_color_suffix} 
  ${Green_font_prefix}8.${Font_color_suffix} 
  ${Green_font_prefix}9.${Font_color_suffix} 
  ${Green_font_prefix}10.${Font_color_suffix} 
  ${Green_font_prefix}11.${Font_color_suffix} 
  ${Green_font_prefix}12.${Font_color_suffix} 
  ${Green_font_prefix}13.${Font_color_suffix} 
  ${Green_font_prefix}14.${Font_color_suffix} 
  ${Green_font_prefix}15.${Font_color_suffix} 
 "
	menu_status
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Install
	;;
	2)
	cg_passwd
	;;
	3)
	
	;;
	4)
	
	;;
	5)
	
	;;
	6)
	
	;;
	7)
	
	;;
	8)
	
	;;
	9)
	
	;;
	10)
	
	;;
	11)
	
	;;
	12)
	
	;;
	13)
	
	;;
	14)
	
	;;
	15)
	
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
esac
fi

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 1.1.2
#	Author: johnpoint
#=================================================

sh_ver=1.1.2

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

#Install_something
Install_something(){
wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/install.sh && chmod +x install.sh && ./install.sh
}
#CG_passwd
CG_passwd(){
passwd
}
#Look_uname
Look_uname(){
uname -a
}
#Login_key
Login_key(){
wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/ssh_key.sh && chmod +x ssh_key.sh && ./ssh_key.sh
}

 
 if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  VPS一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 软件
  ${Green_font_prefix}2.${Font_color_suffix} 修改 密码
  ${Green_font_prefix}3.${Font_color_suffix} 查看 系统信息
  ${Green_font_prefix}4.${Font_color_suffix} 更改 系统为密钥登陆
————————————
  ${Green_font_prefix}5.${Font_color_suffix} 
  ${Green_font_prefix}6.${Font_color_suffix} 
  ${Green_font_prefix}7.${Font_color_suffix} 
  ${Green_font_prefix}8.${Font_color_suffix} 
  ${Green_font_prefix}9.${Font_color_suffix} 
 "
	menu_status
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Install_something
	;;
	2)
	CG_passwd
	;;
	3)
	Look_uname
	;;
	4)
	Login_key
	;;
	5)
	
	;;
	6)
	
	;;
	7)
	
	;;
	8)
	
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
esac
fi


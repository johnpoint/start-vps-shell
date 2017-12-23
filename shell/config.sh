#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 8.6.0
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="8.6.0"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"

#check_root
[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1

#check OS
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
 else
    echo -e "${Error}无法识别~"
    exit 0
fi

not_found(){
echo -e "${Tip}404 Not Found"
echo -e "${Green_font_prefix}你来到了一片荒芜之地~${Font_color_suffix}"
}

Out_ip(){
ip_config=$( curl -s ipinfo.io )
echo "$ip_config" > 
}

Read_config(){
 echo && stty erase '^H' && read -p "请输入配置文件路径路径：" w_config

}

Out_config(){
Out_ip
}







echo -e "  VPS一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  
  ================= IP Information =====================
  =${Green_font_prefix}$ip${Font_color_suffix}
  =${Green_font_prefix}位置：${Font_color_suffix}$country $region $city 
  =${Green_font_prefix}经纬：${Font_color_suffix}$loc
  =${Green_font_prefix}组织：${Font_color_suffix}$org
  =============== System Information ===================
  =${Green_font_prefix}OS${Font_color_suffix} : $opsy
  =${Green_font_prefix}Arch${Font_color_suffix} : $arch ($lbit Bit)
  =${Green_font_prefix}Kernel${Font_color_suffix} : $kern
  =${Green_font_prefix}BBR${Font_color_suffix} : $bbr
  ==================================================
  ${Green_font_prefix}1.${Font_color_suffix} 生成 配置文件
  ${Green_font_prefix}2.${Font_color_suffix} 导入 配置文件
  ${Green_font_prefix}3.${Font_color_suffix} 读取 配置文件
 "
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Out_config
	;;
	2)
	In_config
	;;
	3)
	Read_config
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
 esac
 fi
 done
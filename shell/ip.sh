#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 0.0.1
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="0.0.1"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}
ip(){
curl "ipinfo.io"|grep -Po '"ip":".*?"' | grep -Po '\d+'
}
ip=$(ip)
city=$(curl "ipinfo.io"|grep -Po '"city":".*?"' | grep -Po '\d+')
country=$(curl "ipinfo.io"|grep -Po '"country":".*?"' | grep -Po '\d+')
loc=$(curl "ipinfo.io"|grep -Po '"loc":".*?"' | grep -Po '\d+')
org=$(curl "ipinfo.io"|grep -Po '"org":".*?"' | grep -Po '\d+')

echo -e "
ip概况
IP地址：$(ip)
位置：$(country) $(city) $(loc)
组织：$(org)
"
done
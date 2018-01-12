#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 0.0.4-2
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="0.0.4-2"
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
exit 0
}

Install(){
cd /home
mkdir /home/rssbot
cd /home/rssbot
wget https://github.com/iovxw/rssbot/releases/download/v1.4.1-limited/rssbot-v1.4.1-limited-linux.zip
unzip rssbot-v1.4.1-limited-linux.zip
rm -rf rssbot-v1.4.1-limited-linux.zip
 echo && stty erase '^H' && read -p "请输入bot api key：" apikey
touch rssbot_config.json
echo "
{
"key" = "$apikey"
}
" > rss_config.json
touch rssbotactive.sh
echo "
#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd ~
./rssbot.sh s
" > rssbotactive.sh
echo "*/1 * * * * bash /home/rssbot/rssbotactive.sh" >> /var/spool/cron/root
 echo -e "${Tip} 服务端部署完成~"
 cd ~
 ./rssbot.sh
}

Uninstall(){
echo "确定要 卸载 rss_bot ？[y/N]" && echo
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
	Stop
    cd /
    rm -rf /home/rssbot

	echo -e "${Tip} 卸载完成~"
	else
	echo -e "${Info} 卸载已取消...."
fi
}

key(){
cat rss_config.json | jq '.key' | sed 's/\"//g'
}

Start(){
key=$(key)
 cd /home/rssbot
  ./rssbot rss.json $key
}

Stop(){
  exit 1
}


menu(){
echo -e "  rss_bot ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  ${Tip}建议在screen环境中运行此脚本
  ${Green_font_prefix}1.${Font_color_suffix} 安装 rss bot
  ${Green_font_prefix}2.${Font_color_suffix} 卸载 rss bot
   ——————————————————————
  ${Green_font_prefix}3.${Font_color_suffix} 启动 rss bot
  ${Green_font_prefix}4.${Font_color_suffix} 停止 rss bot
  ${Green_font_prefix}5.${Font_color_suffix} 重启 rss bot
 "
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Install
	;;
	2)
	Uninstall
	;;
	3)
	Start
	;;
	4)
	Stop
	;;
	5)
	Stop
	Start
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
 esac
 exit
}
 
action=$1
if [[ ! -z $action ]]; then
	if [[ $action = "s" ]]; then
		Start
	else
	echo "正常打开脚本"
	menu
else
	menu
fi

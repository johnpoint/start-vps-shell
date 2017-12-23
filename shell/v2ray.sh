#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 0.0.2
#	Blog: blog.lvcshu.club
#	Author: Kirito && 雨落无声'
#    修改：johnpoint
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="0.0.2"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"

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
 
 #Disable China
Disable_China(){
 wget http://iscn.kirito.moe/run.sh 
 bash run.sh 
 if [[ $area == cn ]];then 
 echo "Unable to install in china" 
 exit 
 fi 
 }
 #Check Root 
 [ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; } 
  
 # Get Public IP address 
 Get_ip(){
 ipc=$(ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1) 
 if [[ "$IP" = "" ]]; then 
 ipc=$(wget -qO- -t1 -T2 ipv4.icanhazip.com) 
 fi 
 }
 
Get_uuid(){
 uuid=$(cat /proc/sys/kernel/random/uuid) 
 }
  
 Install_Basic_Packages(){
 ${PM} update
 ${PM} install curl wget unzip ntp ntpdate -y 
  }
 Set_DNS(){
 echo "nameserver 8.8.8.8" > /etc/resolv.conf 
 echo "nameserver 8.8.4.4" >> /etc/resolv.conf 
  }
 Update_NTP_settings(){
 rm -rf /etc/localtime 
 ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
 ntpdate us.pool.ntp.org
 }
 
 Disable_SELinux(){
 if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then 
 sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 
 setenforce 0 
 fi 
 }
 
 Start(){
service v2ray start 
}

Stop(){
service v2ray stop
}

Restart(){
service v2ray stop
service v2ray start 
}
 
 Set_config(){
echo 'V2Ray 一键安装|配置脚本 Author：Kirito && 雨落无声' 
 echo '' 
 echo '此脚本会关闭iptables防火墙，切勿用于生产环境！' 
 while :; do echo 
 read -p "输入用户等级（自用请输入1，共享请输入0）:" level 
 if [[ ! $level =~ ^[0-1]$ ]]; then 
 echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}" 
 else 
 break 
 fi 
 done 
 echo '' 
 read -p "输入主要端口（默认：32000）:" mainport 
 [ -z "$mainport" ] && mainport=32000 
 echo '' 
 read -p "是否启用HTTP伪装?（默认开启） [y/n]:" ifhttpheader 
 [ -z "$ifhttpheader" ] && ifhttpheader='y' 
 if [[ $ifhttpheader == 'y' ]];then 
 httpheader=', 
 "streamSettings": { 
 "network": "tcp", 
 "tcpSettings": { 
 "connectionReuse": true, 
 "header": { 
 "type": "http", 
 "request": { 
 "version": "1.1", 
 "method": "GET", 
 "path": ["/"], 
 "headers": { 
 "Host": ["www.baidu.com", "www.sogou.com/"], 
 "User-Agent": [ 
 "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36", 
 "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/601.1 (KHTML, like Gecko) CriOS/53.0.2785.109 Mobile/14A456 Safari/601.1.46" 
 ], 
 "Accept-Encoding": ["gzip, deflate"], 
 "Connection": ["keep-alive"], 
 "Pragma": "no-cache" 
 } 
 }, 
 "response": { 
 "version": "1.1", 
 "status": "200", 
 "reason": "OK", 
 "headers": { 
 "Content-Type": ["application/octet-stream", "application/x-msdownload", "text/html", "application/x-shockwave-flash"], 
 "Transfer-Encoding": ["chunked"], 
 "Connection": ["keep-alive"], 
 "Pragma": "no-cache" 
 } 
 } 
 } 
 } 
 }' 
 else 
 httpheader='' 
 read -p "是否启用mKCP协议?（默认开启） [y/n]:" ifmkcp 
 [ -z "$ifmkcp" ] && ifmkcp='y' 
 if [[ $ifmkcp == 'y' ]];then 
 mkcp=', 
 "streamSettings": { 
 "network": "kcp" 
 }' 
 else 
 mkcp='' 
 fi 
 fi 
  
 echo '' 
  
 read -p "是否启用动态端口?（默认开启） [y/n]:" ifdynamicport 
 [ -z "$ifdynamicport" ] && ifdynamicport='y' 
 if [[ $ifdynamicport == 'y' ]];then 
  
 read -p "输入数据端口起点（默认：32001）:" subport1 
 [ -z "$subport1" ] && subport1=32000 
  
 read -p "输入数据端口终点（默认：32500）:" subport2 
 [ -z "$subport2" ] && subport2=32500 
  
 read -p "输入每次开放端口数（默认：10）:" portnum 
 [ -z "$portnum" ] && portnum=10 
  
 read -p "输入端口变更时间（单位：分钟）:" porttime 
 [ -z "$porttime" ] && porttime=5 
 dynamicport=" 
 \"inboundDetour\": [ 
 { 
 \"protocol\": \"vmess\", 
 \"port\": \"$subport1-$subport2\", 
 \"tag\": \"detour\", 
 \"settings\": {}, 
 \"allocate\": { 
 \"strategy\": \"random\", 
 \"concurrency\": $portnum, 
 \"refresh\": $porttime 
 }${mkcp}${httpheader} 
 } 
 ], 
 " 
 else 
 dynamicport='' 
 fi 
  
 echo '' 
  
 read -p "是否启用 Mux.Cool?（默认开启） [y/n]:" ifmux 
 [ -z "$ifmux" ] && ifmux='y' 
 if [[ $ifmux == 'y' ]];then 
 mux=', 
 "mux": { 
 "enabled": true 
 } 
 ' 
 else 
 mux="" 
 fi 
  
 while :; do echo 
 echo '1. HTTP代理（默认）' 
 echo '2. Socks代理' 
 read -p "请选择客户端代理类型: " chooseproxytype 
 [ -z "$chooseproxytype" ] && chooseproxytype=1 
 if [[ ! $chooseproxytype =~ ^[1-2]$ ]]; then 
 echo '输入错误，请输入正确的数字！' 
 else 
 break 
 fi 
 done 
  
 if [[ $chooseproxytype == 1 ]];then 
 proxytype='http' 
 else 
 proxytype='socks' 
 fi 
  
  
 #CheckIfInstalled 
 if [ ! -f "/usr/bin/v2ray/v2ray" ]; then 
 Install 
 fi 
  
 #Disable iptables 
 iptables -P INPUT ACCEPT 
 iptables -P FORWARD ACCEPT 
 iptables -P OUTPUT ACCEPT 
 iptables -F 
  
 #Configure Server 
 Stop
 rm -rf config 
 cat << EOF > config 
 {"log" : { 
 "access": "/var/log/v2ray/access.log", 
 "error": "/var/log/v2ray/error.log", 
 "loglevel": "warning" 
 }, 
 "inbound": { 
 "port": $mainport, 
 "protocol": "vmess", 
 "settings": { 
 "clients": [ 
 { 
 "id": "$uuid", 
 "level": $level, 
 "alterId": 100 
 } 
 ] 
 }${mkcp}${httpheader} 
 }, 
 "outbound": { 
 "protocol": "freedom", 
 "settings": {} 
 }, 
  
 ${dynamicport} 
  
 "outboundDetour": [ 
 { 
 "protocol": "blackhole", 
 "settings": {}, 
 "tag": "blocked" 
 } 
 ], 
 "routing": { 
 "strategy": "rules", 
 "settings": { 
 "rules": [ 
 { 
 "type": "field", 
 "ip": [ 
 "0.0.0.0/8", 
 "10.0.0.0/8", 
 "100.64.0.0/10", 
 "127.0.0.0/8", 
 "169.254.0.0/16", 
 "172.16.0.0/12", 
 "192.0.0.0/24", 
 "192.0.2.0/24", 
 "192.168.0.0/16", 
 "198.18.0.0/15", 
 "198.51.100.0/24", 
 "203.0.113.0/24", 
 "::1/128", 
 "fc00::/7", 
 "fe80::/10" 
 ], 
 "outboundTag": "blocked" 
 } 
 ] 
 } 
 } 
 } 
 EOF 
 rm -rf /etc/v2ray/config.back 
 mv /etc/v2ray/config.json /etc/v2ray/config.back 
 mv config /etc/v2ray/config.json 
  
 rm /root/config.json 
 cat << EOF > /root/config.json 
 { 
 "log": { 
 "loglevel": "info" 
 }, 
 "inbound": { 
 "port": 1080, 
 "listen": "127.0.0.1", 
 "protocol": "$proxytype", 
 "settings": { 
 "auth": "noauth", 
 "udp": true, 
 "ip": "127.0.0.1" 
 } 
 }, 
 "outbound": { 
 "protocol": "vmess", 
 "settings": { 
 "vnext": [ 
 { 
 "address": "$ipc", 
 "port": $mainport, 
 "users": [ 
 { 
 "id": "$uuid", 
 "alterId": 100 
 } 
 ] 
 } 
 ] 
 }${mkcp}${httpheader}${mux} 
 }, 
 "outboundDetour": [ 
 { 
 "protocol": "freedom", 
 "settings": {}, 
 "tag": "direct" 
 } 
 ], 
 "dns": { 
 "servers": [ 
 "8.8.8.8", 
 "8.8.4.4", 
 "localhost" 
 ] 
 }, 
 "routing": { 
 "strategy": "rules", 
 "settings": { 
 "rules": [ 
 { 
 "type": "chinasites", 
 "outboundTag": "direct" 
 }, 
 { 
 "type": "field", 
 "ip": [ 
 "0.0.0.0/8", 
 "10.0.0.0/8", 
 "100.64.0.0/10", 
 "127.0.0.0/8", 
 "169.254.0.0/16", 
 "172.16.0.0/12", 
 "192.0.0.0/24", 
 "192.0.2.0/24", 
 "192.168.0.0/16", 
 "198.18.0.0/15", 
 "198.51.100.0/24", 
 "203.0.113.0/24", 
 "::1/128", 
 "fc00::/7", 
 "fe80::/10" 
 ], 
 "outboundTag": "direct" 
 }, 
 { 
 "type": "chinaip", 
 "outboundTag": "direct" 
 } 
 ] 
 } 
 } 
 } 
 EOF 
 Start
 clear 
 #INstall Success 
 echo 'Telegram Group: https://t.me/functionclub' 
 echo 'Google Puls: https://plus.google.com/communities/113154644036958487268' 
 echo 'Github: https://github.com/FunctionClub' 
 echo 'QQ Group:277717865' 
 echo 'Function Club 无限期停更说明' 
 echo 'https://www.ixh.me/2017/05/function-club-stop/' 
 echo '教程地址：https://github.com/FunctionClub/V2ray-Bash/blob/master/README.md' 
 echo '配置完成，客户端配置文件在 /root/config.json' 
 echo '' 
 echo "程序主端口：$mainport" 
 echo "UUID: $uuid" 
}

Install(){ 
Disable_China
Install_Basic_Packages
Set_DNS
Update_NTP_settings
Disable_SELinux
Get_uuid
Get_ip
cd /root 
 bash <(curl -L -s https://install.direct/go.sh) 
 clear 
 Set_config
 cd ~
 mkdir v2ray
 mv config.json /root/v2ray
 }
 
 Uninstall(){
 echo "确定要 卸载 v2ray ？[y/N]" && echo
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
	Stop
	cd ~
	rm -rf config.json
	cd /etc
	rm -rf v2ray
	echo -e "${Tip} 卸载完成~"
	else
	echo -e "${Info} 卸载已取消...."
fi
}

View_config(){
cd ~/v2ray
cat config.json
}
 
 
 echo -e "  VPS一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  
  ${Green_font_prefix}1.${Font_color_suffix} 安装 v2ray
  ${Green_font_prefix}2.${Font_color_suffix} 卸载 v2ray
   ——————————————————————
  ${Green_font_prefix}3.${Font_color_suffix} 启动 v2ray
  ${Green_font_prefix}4.${Font_color_suffix} 停止 v2ray
  ${Green_font_prefix}5.${Font_color_suffix} 重启 v2ray
   ——————————————————————
  ${Green_font_prefix}6.${Font_color_suffix} 查看 v2ray配置
  ${Green_font_prefix}7.${Font_color_suffix} 设置 v2ray配置
   ——————————————————————
  ${Green_font_prefix}0.${Font_color_suffix} 更新 脚本
  ${Tip}此脚本会关闭iptables防火墙，切勿用于生产环境!
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
	Restart
	;;
	6)
	View_config
	;;
	7)
	Set_config
	;;
    0)
	Update_shell
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
 esac
 fi

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 5.0
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#=================================================

sh_ver="5.0"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"
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
 #Install_status(安装基于lnmp的status，未完工
 Install_stats(){
 cd ~
 wget https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/ServerStatus.zip
 echo '正在安装unzip...'
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install unzip -y 
 else 
 apt-get update 
 apt-get install unzip -y 
 fi 
 echo '安装完成！'
 unzip ServerStatus.zip
 cd ServerStatus/server
 make
 echo '如果没错误提示，OK，ctrl+c关闭；如果有错误提示，检查35601端口是否被占用'
 ./sergate
 echo && stty erase '^H' && read -p "请输入域名：" status_yuming
 cp -r ServerStatus/web/* /home/wwwroot/$status_yuming
 ./sergate --config=config.json --web-dir=/home/wwwroot/$status_yuming  
 }
 #Install_status
 Install_status(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/status.sh && chmod +x status.sh
 bash status.sh s
 }
 #Install_v2ray
 Install_v2ray(){
 #Disable China 
 wget http://iscn.kirito.moe/run.sh 
 . ./run.sh 
 if [[ $area == cn ]];then 
 echo "Unable to install in china" 
 exit 
 fi 
 # Get Public IP address 
 ipc=$(ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1) 
 if [[ "$IP" = "" ]]; then 
 ipc=$(wget -qO- -t1 -T2 ipv4.icanhazip.com) 
 fi 
  
 uuid=$(cat /proc/sys/kernel/random/uuid) 
 
 function Install(){ 
 #Install Basic Packages 
 if [[ ${OS} == 'CentOS' ]];then 
 yum install curl wget unzip ntp ntpdate -y 
 else 
 apt-get update 
 apt-get install curl unzip ntp wget ntpdate -y 
 fi 
  
 #Set DNS 
 echo "nameserver 8.8.8.8" > /etc/resolv.conf 
 echo "nameserver 8.8.4.4" >> /etc/resolv.conf 
  
  
 #Update NTP settings 
 rm -rf /etc/localtime 
 ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
 ntpdate us.pool.ntp.org 
  
 #Disable SELinux 
 if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then 
 sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 
 setenforce 0 
 fi 
  
 #Run Install 
 cd /root 
  
 bash <(curl -L -s https://install.direct/go.sh) 
  
 } 
  
 clear 
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
 echo " {
 "log" : { 
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
 ">config
 rm -rf /etc/v2ray/config.back 
 mv /etc/v2ray/config.json /etc/v2ray/config.back 
 mv config /etc/v2ray/config.json 
 rm /root/config.json 
 echo "{
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
 } ">/root/config.json 
 service v2ray start 
 clear 
 #INstall Success 
 echo 'Telegram Group: https://t.me/functionclub' 
 echo 'Google Puls: https://plus.google.com/communities/113154644036958487268' 
 echo 'Github: https://github.com/FunctionClub' 
 echo 'QQ Group:*********' 
 echo 'Function Club 无限期停更说明' 
 echo 'https://www.ixh.me/2017/05/function-club-stop/' 
 echo '教程地址：https://github.com/FunctionClub/V2ray-Bash/blob/master/README.md' 
 echo '配置完成，客户端配置文件在 /root/config.json' 
 echo '' 
 echo "程序主端口：$mainport" 
 echo "UUID: $uuid" 
 }
 #Install_sync
 Install_sync(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/sync.sh && chmod +x sync.sh && ./sync.sh
 }
 #Install_ytb_dl
 Install_ytb_dl(){
 cd ~
 wget https://yt-dl.org/downloads/2017.10.01/youtube-dl -O /usr/local/bin/youtube-dl
 chmod a+rx /usr/local/bin/youtube-dl
 youtube-dl -U
 echo && stty erase '^H' && read -p "请输入保存路径：" save
 cd $save
 echo && stty erase '^H' && read -p "请输入视频地址：" address
 youtube-dl $address
 }
 #Install_EFB
 Install_EFB(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/EFB.sh && chmod +x EFB.sh && ./EFB.sh
 }
 #Install_wordpress
 Install_wordpress(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/wordpress.sh && chmod +x wordpress.sh && ./wordpress.sh
 }
 #Install_GoFlyway
 Install_GoFlyway(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/goflyway.sh && chmod +x goflyway.sh && bash goflyway.sh
 }
 #Install_something
Install_something(){
echo && echo -e "  你要做什么？
	
  ${Green_font_prefix}1.${Font_color_suffix} 安装 screen
  ${Green_font_prefix}2.${Font_color_suffix} 安装 lrzsz
  ${Green_font_prefix}3.${Font_color_suffix} 安装 git
  ${Green_font_prefix}4.${Font_color_suffix} 安装/管理 ssr
  ${Green_font_prefix}5.${Font_color_suffix} 安装/管理 逗逼监控
  ${Green_font_prefix}6.${Font_color_suffix} 安装 V2ray
  ${Green_font_prefix}7.${Font_color_suffix} 安装 Sync
  ${Green_font_prefix}8.${Font_color_suffix} 安装/使用 youtube-dl
  ${Green_font_prefix}9.${Font_color_suffix} 安装微信互联系统（限Ubuntu）
  ${Green_font_prefix}10.${Font_color_suffix} 安装 wordpress博客
  ${Green_font_prefix}11.${Font_color_suffix} 安装/管理 GoFlyway
  ——" && echo
	stty erase '^H' && read -p "(默认: 取消):" install_num
	[[ -z "${install_num}" ]] && echo "已取消..." && exit 1
	if [[ ${install_num} == "1" ]]; then
		Install_screen
	elif [[ ${install_num} == "2" ]]; then
		Install_lrzsz
	elif [[ ${install_num} == "3" ]]; then
		Install_git
	elif [[ ${install_num} == "4" ]]; then
		Install_ssr
	elif [[ ${install_num} == "5" ]]; then
		Install_status
	elif [[ ${install_num} == "6" ]]; then
		Install_v2ray
	elif [[ ${install_num} == "7" ]]; then
		Install_sync
	elif [[ ${install_num} == "8" ]]; then
		Install_ytb_dl
	elif [[ ${install_num} == "9" ]]; then
		Install_EFB
	elif [[ ${install_num} == "10" ]]; then
		Install_wordpress
	elif [[ ${install_num} == "11" ]]; then
		Install_GoFlyway
	else
		echo -e "${Error} 请输入正确的数字 [1-10]" && exit 1
	fi
}
#CG_passwd
CG_passwd(){
passwd
}
#Look_uname
Look_uname(){
uname -a
}
#install openssl
 Install_openssl(){
 echo '正在安装openssl...'
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install openssl -y 
 else 
 apt-get update 
 apt-get install openssl -y 
 fi 
 echo '安装完成！'
 }
 #Generate_key
 Generate_key(){
 echo '正在生成key'
 ssh-keygen
 echo '生成成功，保存于 /root/.ssh'
 cd .ssh
 mv id_rsa.pub authorized_keys
 ls -a
 chmod 600 authorized_keys
 chmod 700 ~/.ssh
 }
 #modify_sshd_config
 modify_sshd_config(){
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 mkdir ~/sshd_config
 cp /etc/ssh/sshd_config /root/sshd_config
 echo '请寻找RSAAuthentication yes PubkeyAuthentication yes 如不为yes 则改为yes'
 echo '请寻找RSAAuthentication yes PubkeyAuthentication yes 如不为yes 则改为yes'
 echo '请寻找RSAAuthentication yes PubkeyAuthentication yes 如不为yes 则改为yes'
 vi /etc/ssh/sshd_config
 echo '正在重启ssh服务'
 echo '请使用key登陆测试是否成功'
 }
 #Download_key
 Download_key(){
 cd ~/.ssh
 cat id_rsa
 echo '把屏幕上面的密匙复制出来写入文件内，文件取名为 id_rsa （这个名称随意，但这个密匙文件一定要保存好！）。'
 }
 #Upload_key
 Upload_key(){
 mkdir ~/.ssh
 if [[ ${OS} == 'CentOS' ]];then 
 yum update -y
 yum install lrzsz -y
 else 
 apt-get update 
 apt-get install lrzsz -y
 fi 
 cd ~/.ssh
 rz -y
 ls -a
 chmod 600 authorized_keys
 chmod 700 ~/.ssh
 }
 #restart_sshd
 restart_sshd(){
 echo '正在重启ssh服务'
 service ssh restart
 service sshd restart
 }
 #close_passwd
 close_passwd(){
 echo '将PasswordAuthentication 改为no 并去掉#号'
 echo '将PasswordAuthentication 改为no 并去掉#号'
 echo '将PasswordAuthentication 改为no 并去掉#号'
 echo '将PasswordAuthentication 改为no 并去掉#号'
 vi /etc/ssh/sshd_config
 echo '记得重启'
 }
#Login_key
Login_key(){
echo && echo -e "  你要做什么？
	
  ${Green_font_prefix}1.${Font_color_suffix} 安装 openssl
  ${Green_font_prefix}2.${Font_color_suffix} 生成 key
  ${Green_font_prefix}3.${Font_color_suffix} 取回 私钥
  ${Green_font_prefix}4.${Font_color_suffix} 上传 key（多服务端单key选此项）
  ${Green_font_prefix}5.${Font_color_suffix} 修改 sshd_config文件
  ${Green_font_prefix}6.${Font_color_suffix} 重启 ssh服务
  ${Green_font_prefix}7.${Font_color_suffix} 关闭 密码登陆
  ——" && echo
	stty erase '^H' && read -p "(默认: 取消):" Login_key_num
	[[ -z "${Login_key_num}" ]] && echo "已取消..." && exit 1
	if [[ ${Login_key_num} == "1" ]]; then
		Install_openssl
	elif [[ ${Login_key_num} == "2" ]]; then
		Generate_key
	elif [[ ${Login_key_num} == "3" ]]; then
		Download_key
	elif [[ ${Login_key_num} == "4" ]]; then
		Upload_key
	elif [[ ${Login_key_num} == "5" ]]; then
		modify_sshd_config
	elif [[ ${Login_key_num} == "6" ]]; then
		restart_sshd
	elif [[ ${Login_key_num} == "7" ]]; then
		close_passwd
	else
		echo -e "${Error} 请输入正确的数字 [1-7]" && exit 1
	fi
}
#Update_shell
Update_shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="yun"
	[[ -z ${sh_new_ver} ]] && sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="github"
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		stty erase '^H' && read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			cd "${file}"
			if [[ $sh_new_type == "yun" ]]; then
				wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh
			else
				wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh
			fi
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
	fi
	exit 0
}


echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="yun"
	[[ -z ${sh_new_ver} ]] && sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="github"
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		stty erase '^H' && read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			cd "${file}"
			if [[ $sh_new_type == "yun" ]]; then
				wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh
			else
				wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh
			fi
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
	fi

 if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  VPS一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 软件
  ${Green_font_prefix}2.${Font_color_suffix} 修改 密码
  ${Green_font_prefix}3.${Font_color_suffix} 查看 系统信息
  ${Green_font_prefix}4.${Font_color_suffix} 更改 系统为密钥登陆
  ——————————————————————
  ${Green_font_prefix}0.${Font_color_suffix} 更新 脚本
 "
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
	0)
	Update_shell
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
esac
fi
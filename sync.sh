#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 0.0.1
#	Author: johnpoint
#=================================================

sh_ver=0.0.1

#Install_sync
Install_sync(){
cd ~
mkdir sync
cd sync
ldconfig
　　if ［ $（getconf WORD_BIT） = ‘32’ ］ && ［ $（getconf LONG_BIT） = ‘64’ ］ ; then
　　wget -O sync.tar.gz https://download-cdn.resilio.com/stable/linux-i386/resilio-sync_i386.tar.gz
　　else
　　wget -O sync.tar.gz https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz
　　fi
tar -xzf sync.tar.gz && rm -rf sync.tar.gz
chmod +x rslsync
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}
#Start_sync
Start_sync(){
cd /root/sync
./rslsync --webui.listen 0.0.0.0:8888
get_IP_address(){
	#echo "user_IP_1=${user_IP_1}"
	if [[ ! -z ${user_IP_1} ]]; then
	#echo "user_IP_total=${user_IP_total}"
		for((integer_1 = ${user_IP_total}; integer_1 >= 1; integer_1--))
		do
			IP=`echo "${user_IP_1}" |sed -n "$integer_1"p`
			#echo "IP=${IP}"
			IP_address=`wget -qO- -t1 -T2 http://freeapi.ipip.net/${IP}|sed 's/\"//g;s/,//g;s/\[//g;s/\]//g'`
			#echo "IP_address=${IP_address}"
			user_IP="${user_IP}\n${IP}(${IP_address})"
			#echo "user_IP=${user_IP}"
			sleep 1s
		done
	fi
}
echo '网址：http://{ip}:8888'
}
#Stop_sync
Stop_sync(){
cd /root/sync
kill -9 $(ps -ef|grep "rslsync"|grep -v grep|awk '{print $2}')
}
#Uninstall_sync
Uninstall_sync(){
cd ~
rm -rf /root/sync
}
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}

 if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  VPS一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 Resilio Sync
  ${Green_font_prefix}2.${Font_color_suffix} 启动 Resilio Sync
  ${Green_font_prefix}3.${Font_color_suffix} 停止 Resilio Sync
  ${Green_font_prefix}4.${Font_color_suffix} 卸载 Resilio Sync
  "
	menu_status
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Install_sync
	;;
	2)
	Start_sync
	;;
	3)
	Stop_sync
	;;
	4)
	Uninstall_sync
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-2]"
	;;
esac
fi
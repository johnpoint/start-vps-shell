#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	Version: 0.0.1
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v3
#=================================================

sh_ver="2.2.15"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
IPT="iptables"
SPAMLIST="blockedip"
SPAMDROPMSG="BLOCKED IP DROP"
SYSCTL="sysctl"
BLOCKEDIPS="/root/scripts/blocked.ips.txt"
Separator_1="——————————————————————————————"

[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1

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

${PM} update -y > /dev/null
${PM} install iptables -y > /dev/null

Start(){
echo -e "${Info}启动iptables"
service iptables start
}

Stop(){
echo -e "${Info}关闭iptables"
service iptables stop
}

Restart(){
Stop
Start
}

View_rules(){
iptables -L -n
}

Search_rules(){
echo "请输入要查询的关键字"
read search
echo -e "${Info}查询结果"
iptables -L -n | grep ${search}
}

Set_rules(){

	

Rules1(){
echo "是否开放环回接口（本机连接本机）[y/n]" && read yn
if [[ ${yn} == 'y' ]]; then
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A OUTPUT -o lo -j ACCEPT
else
	echo "不作配置"
fi
}
Rules2(){
sshport=$(cat /etc/ssh/sshd_config | grep Port)
echo -e "${Tip}您的ssh端口为 ${Green_font_prefix}${sshport}${Font_color_suffix}"
if [[ ${sshport} == '22' ]]; then
	echo -e "${Tip}默认ssh端口有风险！"
else
	echo "仅供参考"
fi
echo "输入ssh端口" read ssh
iptables -A INPUT -p tcp --dport ${ssh} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${ssh} -j ACCEPT 
)
Rules3(){
echo "是否允许ping[y/n]" && read yn
if [[ ${yn} == 'y' ]]; then
	iptables -A INPUT -p icmp -j ACCEPT
else
	echo "不作配置"
fi
}
Rules4(){
echo "是否开启web端口（80）[y/n]" && read yn
if [[ ${yn} == 'y' ]]; then
	iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
	iptables -A INPUT -p tcp --dport 80 -j ACCEPT
else
	echo "不作配置"
fi
}
Rules5(){
echo "是否开启443端口" && read yn
if [[ ${yn} == 'y' ]]; then
	iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT
	iptables -A INPUT -p tcp --dport 443 -j ACCEPT
else
	echo "不作配置"
fi
}
Rules6(){
echo "是否允许DNS服务（53）" && read yn
if [[ ${yn} == 'y' ]]; then
	iptables -A INPUT -p tcp --dport 53 -j ACCEPT
	iptables -A INPUT -i lo -p all -j ACCEPT
	iptables -A OUTPUT -o lo -p all -j ACCEPT
else
	echo "不作配置"
fi
}
Rules7(){
echo "是否允许icmp服务" && read yn
if [[ ${yn} == 'y' ]]; then
	iptables -A OUTPUT -p icmp -j ACCEPT
	iptables -A INPUT -p icmp -j ACCEPT
else
	echo "不作配置"
fi
}
Rules8(){
iptables -A FORWARD -p TCP ! --syn -m state --state NEW -j DROP
}

	
	










Set_rules_dev(){
echo -e "
iptables防火墙管理脚本 v${Red_font_prefix}${sh_ver}${Font_color_suffix}
=======Aurthor: johnpoint =======

1.	查看 iptables规则
2.	搜索 iptables规则
——————————————————————————————
3.	新建 iptables规则
3.	删除 iptables规则
3.	修改 iptables规则

" && echo "请选择：" && read mainset
if [[ ${mainset} == '1' ]]; then
	View_rules
elif [[ ${mainset} == '2' ]]; then
	Search_rules
elif [[ ${mainset} == '3' ]]; then
	Add_rules
elif [[ ${mainset} == '4' ]]; then
	Del_rules
elif [[ ${mainset} == '2' ]]; then
	Cg_rules
else
	echo -e "${Error}请输入正确选项"
	exit 0
fi
}

echo -e "
iptables防火墙管理脚本 v${Red_font_prefix}${sh_ver}${Font_color_suffix}
=======Aurthor: johnpoint =======

1.	启动 iptables服务
2.	停止 iptables服务
3.	重启 iptables服务
——————————————————————————————
4.	管理 iptables规则
——————————————————————————————
0.	更新 脚本
" && echo "请选择：" && read mainset
if [[ ${mainset} == '1' ]]; then
	Start
elif [[ ${mainset} == '2' ]]; then
	Stop
elif [[ ${mainset} == '3' ]]; then
	Restart
elif [[ ${mainset} == '4' ]]; then
	Set_rules
elif [[ ${mainset} == '0' ]]; then
	Update_shell
else
	echo -e "${Error}请输入正确选项"
	exit 0
fi



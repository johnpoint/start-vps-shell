#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 0.1.0
#	Blog: johnpoint.github.io
#	Author: johnpoint
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="0.1.0"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"
 
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
  
 Install_Basic_Packages(){
 apt update
 apt install curl wget unzip ntp jq ntpdate -y 
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
 echo -e "${Info} 正在开启v2ray"
service v2ray start 
}

Stop(){
 echo -e "${Info} 正在关闭v2ray"
service v2ray stop
}

Restart(){
Stop
Start
}
 
 Install_main(){
 cd ~
 echo -e "${Tip} 正在使用官方脚本安装v2ray主程序...."
 bash <(curl -L -s https://install.direct/go.sh)
 echo -e "${Tip} 安装完成~"
 }
 
 Disable_iptables(){
 iptables -P INPUT ACCEPT 
 iptables -P FORWARD ACCEPT 
 iptables -P OUTPUT ACCEPT 
 iptables -F 
}
 
  Port_main(){
 read -p "输入主要端口（默认：32000）:" port 
 [ -z "$port" ] && port=32000 
 }
 
 
mkcp(){
read -p "是否启用mKCP协议?（默认开启） [y/n]:" ifmkcp 
 [ -z "$ifmkcp" ] && ifmkcp='y' 
 if [[ $ifmkcp == 'y' ]];then 
 mkcp='
         "streamSettings": {
            "network": "kcp"
        }'
 else 
 mkcp='' 
 fi 
 }




Move_port(){
  read -p "是否启用动态端口?（默认开启） [y/n]:" ifdynamicport 
 [ -z "$ifdynamicport" ] && ifdynamicport='y' 
 if [[ $ifdynamicport == 'y' ]];then 
  
 read -p "输入数据端口起点（默认：32001）:" port1 
 [ -z "$port1" ] && port1=32000 
  
 read -p "输入数据端口终点（默认：32500）:" port2 
 [ -z "$port2" ] && port2=32500 
  
 read -p "输入每次开放端口数（默认：10）:" port_num 
 [ -z "$port_num" ] && portnum=10 
  
 read -p "输入端口变更时间（单位：分钟）:" refresh 
 [ -z "$refresh" ] && refresh=5 
 dynamicport=" 
        {
            "protocol": "vmess",
            "port": "${port1}-${port2}",
            "tag": "detour",
            "settings": {},
            "allocate": {
                "strategy": "random",
                "concurrency": ${port_num},
                "refresh": ${refresh}
            },
 " 
 else 
 dynamicport='' 
 fi 
 }
 
 Max_Cool(){
  read -p "是否启用 Mux.Cool?（默认开启） [y/n]:" ifmux 
 [ -z "$ifmux" ] && ifmux='y' 
 if [[ $ifmux == 'y' ]];then 
 mux='
        "mux": {
            "enabled": true,
            "concurrency": 8
        } 
 ' 
 else 
 mux="" 
 fi 
 }
 
 Client_proxy(){
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
  
 if [[ $chooseproxytype == 1 ]]; then 
 proxy='http' 
 else 
 proxy='socks' 
 fi 
 }
 
 Set_config(){
 echo  "请明确知晓，以下填写内容全都必须填写，否则程序有可能启动失败"
 Port_main
Http_set
Move_port
Max_Cool
Client_proxy
}
 
Save_config(){
Stop
echo -e "${Tip}保存配置~"
echo "
 {
    "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "loglevel": "warning"
    },
    "inbound": {
        "port": ${port},
        "protocol": "vmess",
        "settings": {
            "clients": [
                {
                    "id": "${uuid}",
                    "level": 1,
                    "alterId": 100
                }
            ]
        },
${mkcp},
        "detour": {
            "to": "detour"
        }
    },
    "outbound": {
        "protocol": "freedom",
        "settings": {}
    },
    "inboundDetour": [
${dynamicport}
${mkcp}
        }
    ],
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
" > /etc/v2ray/config.json
}

User_config(){
cd ~
echo "
      {
    "log": {
        "loglevel": "warning"
    },
    "inbound": {
        "listen": "127.0.0.1",
        "port": 1080,
        "protocol": "socks",
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
                    "address": "${ip}",
                    "port": ${port},
                    "users": [
                        {
                            "id": "${uuid}",
                            "level": 1,
                            "alterId": 100
                        }
                    ]
                }
            ]
        },
${mkcp},
${mux}
    },
    "outboundDetour": [
        {
            "protocol": "freedom",
            "settings": {},
            "tag": "direct"
        }
    ],
    "routing": {
        "strategy": "rules",
        "settings": {
            "rules": [
                {
                    "type": "field",
                    "port": "54-79",
                    "outboundTag": "direct"
                },
                {
                    "type": "field",
                    "port": "81-442",
                    "outboundTag": "direct"
                },
                {
                    "type": "field",
                    "port": "444-65535",
                    "outboundTag": "direct"
                },
                {
                    "type": "field",
                    "domain": [
                        "gc.kis.scr.kaspersky-labs.com"
                    ],
                    "outboundTag": "direct"
                },
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
" > /root/user_config.json
echo -e "${Tip} 客户端配置已生成~"
echo "路径：/root/user_config.json"
}

Install(){
Install_Basic_Packages
Set_DNS
Update_NTP_settings
Install_main
Set_config
ip=$( curl -s ipinfo.io | jq '.ip' | sed 's/\"//g' )
uuid=$(cat /proc/sys/kernel/random/uuid) 
Save_config
User_config
clear
echo -e "${Info}配置程序执行完毕~"
Start
}

echo "请选择
1.安装v2ray
2.卸载v2ray
3.启动v2ray
4.停止v2ray
5.重启v2ray
"
read mainset
if [[ ${mainset} == '1' ]]; then
	Install
elif [[ ${mainset} == '2' ]]; then
	Uninstall
elif [[ ${mainset} == '3' ]]; then
	Start
elif [[ ${mainset} == '4' ]]; then
	Stop
elif [[ ${mainset} == '5' ]]; then
	Restart
else
	echo "输入不正确!"
	exit 0
fi
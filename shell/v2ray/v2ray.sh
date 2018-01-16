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
 
 Install_main(){
 cd ~
 echo -e "${Tip} 正在使用官方脚本安装v2ray主程序...."
 bash <(curl -L -s https://install.direct/go.sh)
 echo -e "${Tip} 安装完成~"
 }
 
 Set_config(){
 echo  "请明确知晓，以下填写内容全都必须填写，否则程序有可能启动失败"
 echo "请输入主端口"
 read port
 echo "请输入动态端口起点"
 read port1
 echo "请输入动态端口终点"
 read port2
 echo "请输入动态端口刷新时间"
 read refresh
 echo "同时开放端口数"
 read port_num
 email='123456789@qq.com'
 }
 
Save_config(){
echo -e "${Tip}保存配置~"
echo "
{
"inbound": {
  "port": ${port},
  "protocol": "vmess",
  "settings": {
    "clients": [ 
      {
        "id": "${uuid}",
        "level": 1,
        "alterId": 10,
        "email": "${email}"
      }
    ],
    "detour": {
      "to": "detour"
    }
  }
}
  
  "outbound": {
    "protocol": "freedom",
    "settings": {}
  }
  
  {
  "protocol": "vmess",
  "port": "${port1}-${port2}", 
  "tag": "detour", 
  "settings": {
    "default": {
      "level": 1,
      "alterId": 32
    }
  },
  
  "allocate": { 
    "strategy": "random", 
    "concurrency": ${port_num},
    "refresh": ${refresh}
  }
}
}
" > /etc/v2ray/config.json
}

User_config(){
cd ~
echo "
{
  "inbound": {
    "port": 1080, 
    "listen": "127.0.0.1",
    "protocol": "socks",
    "settings": {
      "udp": true
    }
  },
  "outbound": {
    "protocol": "vmess",
    "settings": {
      "vnext": [{
        "address": "${server}", 
        "port": ${port}, 
        "users": [{ "id": "${uuid}" }]
      }]
    }
  },
  "outboundDetour": [{
    "protocol": "freedom",
    "tag": "direct",
    "settings": {}
  }],
  "routing": {
    "strategy": "rules",
    "settings": {
      "domainStrategy": "IPOnDemand",
      "rules": [{
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
      }]
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
Save_config
User_config
echo -e "${Info}配置程序执行完毕~"
}

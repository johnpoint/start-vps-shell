#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 2.4.2
#	Blog: johnpoint.github.io
#	Author: johnpoint
#	Email: jahanngauss414@gmail.com
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="0.0.1"
shconf="/home/ServerStatus/config.conf"
file="/home/ServerStatus"
server_file="/home/ServerStatus/server"
server_conf="/home/ServerStatus/server/config.json"
client_file="/home/ServerStatus/status-client.py"
client_log_file="/tmp/serverstatus_client.log"
server_log_file="/tmp/serverstatus_server.log"
jq_file="${file}/jq"
port="35601"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#检查权限

[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1

#检测系统

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

#ip地址获取

config=$( curl -s ipinfo.io )
touch ip.json
echo "$config" > ip.json

Ip(){
cat ip.json | jq -r '.ip' 
}

ip=$(Ip)

check_installed_server_status(){
	[[ ! -e "${server_file}" ]] && echo -e "${Error} ServerStatus 服务端没有安装，请检查 !" && exit 1
}
check_installed_client_status(){
	[[ ! -e "${client_file}" ]] && echo -e "${Error} ServerStatus 客户端没有安装，请检查 !" && exit 1
}
check_pid_server(){
	PID=`ps -ef| grep "sergate"| grep -v grep| grep -v ".sh"| grep -v "init.d"| grep -v "service"| awk '{print $2}'`
}
check_pid_client(){
	PID=`ps -ef| grep "status-client.py"| grep -v grep| grep -v ".sh"| grep -v "init.d"| grep -v "service"| awk '{print $2}'`
}
check_config(){
	if [[ ! -e "${server_file}" ]] then
		echo -e "请输入网站域名"
		read yuming
		webfile="/home/wwwroot/${yuming}"
			if [[ ! -e "${server_file}" ]]; then
				echo -e "${Error} 请检查lnmp服务是否安装及是否添加此域名"
				exit 0
			else
				touch ${shconf}
				echo "${yuming}" > ${shconf}
			fi
		else
		echo -e "${Info}载入配置"
		yuming=$(cat ${shconf})
		fi
)

Install_pm2(){
	#判断/usr/bin/pm2文件是否存在
	    if [ ! -f /usr/bin/pm2 ];then
            echo "检查到您未安装pm2,脚本将先进行安装..."
	    #安装Node.js环境
    	    yum -y install xz
    	    yum -y install wget
    	    wget -N https://nodejs.org/dist/v9.4.0/node-v9.4.0-linux-x64.tar.xz
    	    tar -xvf node-v9.4.0-linux-x64.tar.xz
    	    #设置权限
    	    chmod 777 /root/node-v9.4.0-linux-x64/bin/node
    	    chmod 777 /root/node-v9.4.0-linux-x64/bin/npm
    	    #创建软连接
    	    ln -s /root/node-v9.4.0-linux-x64/bin/node /usr/bin/node
    	    ln -s /root/node-v9.4.0-linux-x64/bin/npm /usr/bin/npm
    	    #安装PM2
    	    npm install -g pm2 --unsafe-perm
    	    #创建软连接x2
    	    ln -s /root/node-v9.4.0-linux-x64/bin/pm2 /usr/bin/pm2
}

Download_Server_Status_server(){
	cd /home
	git clone https://github.com/johnpoint/ServerStatus.git
	cd ServerStatus/server
	make
	 echo && echo -e "如果没错误提示，OK，ctrl+c关闭；如果有错误提示，检查35601端口是否被占用    
 " && echo
 stty erase '^H' && read -p "是否继续？（Y/N）（默认：y）" YON
 [[ -z "${install_num}" ]] && ./sergate
	if [[ ${YON} == "y" ]]; then
		./sergate
	elif [[ ${YON} == "n" ]]; then
		exit 1
		else
		./sergate
	fi
}
Download_Server_Status_client(){
	
}
Service_Server_Status_server(){
	
}
Service_Server_Status_client(){
	
}
Installation_dependency(){
	mode=$1
	[[ -z ${mode} ]] && mode="server"
	if [[ ${mode} == "server" ]]; then
		python_status=$(python --help)
		if [[ ${release} == "centos" ]]; then
			yum update
			if [[ -z ${python_status} ]]; then
				yum install -y python unzip vim make
				yum groupinstall "Development Tools" -y
			else
				yum install -y unzip vim make
				yum groupinstall "Development Tools" -y
			fi
		else
			apt-get update
			if [[ -z ${python_status} ]]; then
				apt-get install -y python unzip vim build-essential make
			else
				apt-get install -y unzip vim build-essential make
			fi
		fi
	else
		python_status=$(python --help)
		if [[ ${release} == "centos" ]]; then
			if [[ -z ${python_status} ]]; then
				yum update
				yum install -y python
			fi
		else
			if [[ -z ${python_status} ]]; then
				apt-get update
				apt-get install -y python
			fi
		fi
	fi
}
Write_server_config(){
	cat > ${server_conf}<<-EOF
{"servers":
 [
  {
   "username": "username01",
   "password": "password",
   "name": "Server 01",
   "type": "KVM",
   "host": "MineCloud",
   "location": "RU KHB",
   "disabled": false
  }
 ]
}
EOF
}

Read_config_client(){
	[[ ! -e ${client_file} ]] && echo -e "${Error} ServerStatus 客户端文件不存在 !" && exit 1
	client_text="$(cat "${client_file}"|sed 's/\"//g;s/,//g;s/ //g')"
	client_server="$(echo -e "${client_text}"|grep "SERVER="|awk -F "=" '{print $2}')"
	client_port="$(echo -e "${client_text}"|grep "PORT="|awk -F "=" '{print $2}')"
	client_user="$(echo -e "${client_text}"|grep "USER="|awk -F "=" '{print $2}')"
	client_password="$(echo -e "${client_text}"|grep "PASSWORD="|awk -F "=" '{print $2}')"
}
Set_server(){
	mode=$1
	[[ -z ${mode} ]] && mode="server"
	if [[ ${mode} == "server" ]]; then
		echo -e "请输入 ServerStatus 服务端中网站要设置的 域名[server]
默认为本机IP为域名，例如输入: toyoo.ml，如果要使用本机IP，请留空直接回车"
		stty erase '^H' && read -p "(默认: 本机IP):" server_s
		[[ -z "$server_s" ]] && server_s=""
	else
		echo -e "请输入 ServerStatus 服务端的 IP/域名[server]"
		stty erase '^H' && read -p "(默认: 127.0.0.1):" server_s
		[[ -z "$server_s" ]] && server_s="127.0.0.1"
	fi
	
	echo && echo "	================================================"
	echo -e "	IP/域名[server]: ${Red_background_prefix} ${server_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_server_port(){
	while true
		do
		echo -e "请输入 ServerStatus 服务端中网站要设置的 域名/IP的端口[1-65535]（如果是域名的话，一般建议用 80 端口）"
		stty erase '^H' && read -p "(默认: 8888):" server_port_s
		[[ -z "$server_port_s" ]] && server_port_s="8888"
		expr ${server_port_s} + 0 &>/dev/null
		if [[ $? -eq 0 ]]; then
			if [[ ${server_port_s} -ge 1 ]] && [[ ${server_port_s} -le 65535 ]]; then
				echo && echo "	================================================"
				echo -e "	IP/域名[server]: ${Red_background_prefix} ${server_port_s} ${Font_color_suffix}"
				echo "	================================================" && echo
				break
			else
				echo "输入错误, 请输入正确的端口。"
			fi
		else
			echo "输入错误, 请输入正确的端口。"
		fi
	done
}
Set_username(){
	mode=$1
	[[ -z ${mode} ]] && mode="server"
	if [[ ${mode} == "server" ]]; then
		echo -e "请输入 ServerStatus 服务端要设置的用户名[username]（字母/数字，不可与其他账号重复）"
	else
		echo -e "请输入 ServerStatus 服务端中对应配置的用户名[username]（字母/数字，不可与其他账号重复）"
	fi
	stty erase '^H' && read -p "(默认: 取消):" username_s
	[[ -z "$username_s" ]] && echo "已取消..." && exit 0
	echo && echo "	================================================"
	echo -e "	账号[username]: ${Red_background_prefix} ${username_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_password(){
	password_s="www.lvcshu.club"
	echo && echo "	================================================"
	echo -e "	密码[password]: ${Red_background_prefix} ${password_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_name(){
	echo -e "请输入 ServerStatus 服务端要设置的节点名称[name]（支持中文，前提是你的系统和SSH工具支持中文输入，仅仅是个名字）"
	stty erase '^H' && read -p "(默认: Server 01):" name_s
	[[ -z "$name_s" ]] && name_s="Server 01"
	echo && echo "	================================================"
	echo -e "	节点名称[name]: ${Red_background_prefix} ${name_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_type(){
	echo -e "请输入 ServerStatus 服务端要设置的节点虚拟化类型[type]（例如 OpenVZ / KVM）"
	stty erase '^H' && read -p "(默认: KVM):" type_s
	[[ -z "$type_s" ]] && type_s="KVM"
	echo && echo "	================================================"
	echo -e "	虚拟化类型[type]: ${Red_background_prefix} ${type_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_location(){
	echo -e "请输入 ServerStatus 服务端要设置的节点位置[location]（支持中文，前提是你的系统和SSH工具支持中文输入）"
	stty erase '^H' && read -p "(默认: Hong Kong):" location_s
	[[ -z "$location_s" ]] && location_s="Hong Kong"
	echo && echo "	================================================"
	echo -e "	节点位置[location]: ${Red_background_prefix} ${location_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_config_server(){
	Set_username "server"
	Set_password "server"
	Set_name
	Set_type
	Set_location
}
Set_config_client(){
	Set_server "client"
	Set_username "client"
	Set_password "client"
}

Set_ServerStatus_server(){
	check_installed_server_status
	echo && echo -e " 你要做什么？
	
 ${Green_font_prefix} 1.${Font_color_suffix} 添加 节点配置
 ${Green_font_prefix} 2.${Font_color_suffix} 删除 节点配置
————————
 ${Green_font_prefix} 3.${Font_color_suffix} 修改 节点配置 - 节点用户名
 ${Green_font_prefix} 4.${Font_color_suffix} 修改 节点配置 - 节点密码
 ${Green_font_prefix} 5.${Font_color_suffix} 修改 节点配置 - 节点名称
 ${Green_font_prefix} 6.${Font_color_suffix} 修改 节点配置 - 节点虚拟化
 ${Green_font_prefix} 7.${Font_color_suffix} 修改 节点配置 - 节点位置
 ${Green_font_prefix} 8.${Font_color_suffix} 修改 节点配置 - 全部参数
————————
 ${Green_font_prefix} 9.${Font_color_suffix} 启用/禁用 节点配置" && echo
	stty erase '^H' && read -p "(默认: 取消):" server_num
	[[ -z "${server_num}" ]] && echo "已取消..." && exit 1
	if [[ ${server_num} == "1" ]]; then
		Add_ServerStatus_server
	elif [[ ${server_num} == "2" ]]; then
		Del_ServerStatus_server
	elif [[ ${server_num} == "3" ]]; then
		Modify_ServerStatus_server_username
	elif [[ ${server_num} == "4" ]]; then
		Modify_ServerStatus_server_password
	elif [[ ${server_num} == "5" ]]; then
		Modify_ServerStatus_server_name
	elif [[ ${server_num} == "6" ]]; then
		Modify_ServerStatus_server_type
	elif [[ ${server_num} == "7" ]]; then
		Modify_ServerStatus_server_location
	elif [[ ${server_num} == "8" ]]; then
		Modify_ServerStatus_server_all
	elif [[ ${server_num} == "9" ]]; then
		Modify_ServerStatus_server_disabled
	else
		echo -e "${Error} 请输入正确的数字[1-9]" && exit 1
	fi
	Restart_ServerStatus_server
}
List_ServerStatus_server(){
	conf_text=$(${jq_file} '.servers' ${server_conf}|${jq_file} ".[]|.username"|sed 's/\"//g')
	conf_text_total=$(echo -e "${conf_text}"|wc -l)
	[[ ${conf_text_total} = "0" ]] && echo -e "${Error} 没有发现 一个节点配置，请检查 !" && exit 1
	conf_text_total_a=$(expr $conf_text_total - 1)
	conf_list_all=""
	for((integer = 0; integer <= ${conf_text_total_a}; integer++))
	do
		now_text=$(${jq_file} '.servers' ${server_conf}|${jq_file} ".[${integer}]"|sed 's/\"//g;s/,//g'|sed '$d;1d')
		now_text_username=$(echo -e "${now_text}"|grep "username"|awk -F ": " '{print $2}')
		now_text_password=$(echo -e "${now_text}"|grep "password"|awk -F ": " '{print $2}')
		now_text_name=$(echo -e "${now_text}"|grep "name"|grep -v "username"|awk -F ": " '{print $2}')
		now_text_type=$(echo -e "${now_text}"|grep "type"|awk -F ": " '{print $2}')
		now_text_location=$(echo -e "${now_text}"|grep "location"|awk -F ": " '{print $2}')
		now_text_disabled=$(echo -e "${now_text}"|grep "disabled"|awk -F ": " '{print $2}')
		if [[ ${now_text_disabled} == "false" ]]; then
			now_text_disabled_status="${Green_font_prefix}启用${Font_color_suffix}"
		else
			now_text_disabled_status="${Red_font_prefix}禁用${Font_color_suffix}"
		fi
		conf_list_all=${conf_list_all}"用户名: ${Green_font_prefix}"${now_text_username}"${Font_color_suffix} 密码: ${Green_font_prefix}"${now_text_password}"${Font_color_suffix} 节点名: ${Green_font_prefix}"${now_text_name}"${Font_color_suffix} 类型: ${Green_font_prefix}"${now_text_type}"${Font_color_suffix} 位置: ${Green_font_prefix}"${now_text_location}"${Font_color_suffix} 状态: ${Green_font_prefix}"${now_text_disabled_status}"${Font_color_suffix}\n"
	done
	echo && echo -e "节点总数 ${Green_font_prefix}"${conf_text_total}"${Font_color_suffix}"
	echo -e ${conf_list_all}
}
Add_ServerStatus_server(){
	Set_config_server
	Set_username_ch=$(cat ${server_conf}|grep '"username": "'"${username_s}"'"')
	[[ ! -z "${Set_username_ch}" ]] && echo -e "${Error} 用户名已被使用 !" && exit 1
	sed -i '3i\  },' ${server_conf}
	sed -i '3i\   "disabled": false' ${server_conf}
	sed -i '3i\   "location": "'"${location_s}"'",' ${server_conf}
	sed -i '3i\   "host": "'"None"'",' ${server_conf}
	sed -i '3i\   "type": "'"${type_s}"'",' ${server_conf}
	sed -i '3i\   "name": "'"${name_s}"'",' ${server_conf}
	sed -i '3i\   "password": "'"${password_s}"'",' ${server_conf}
	sed -i '3i\   "username": "'"${username_s}"'",' ${server_conf}
	sed -i '3i\  {' ${server_conf}
	echo -e "${Info} 添加节点成功 ${Green_font_prefix}[ 节点名称: ${name_s}, 节点用户名: ${username_s}, 节点密码: ${password_s} ]${Font_color_suffix} !"
}
Del_ServerStatus_server(){
	List_ServerStatus_server
	[[ "${conf_text_total}" = "1" ]] && echo -e "${Error} 节点配置仅剩 1个，不能删除 !" && exit 1
	echo -e "请输入要删除的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" del_server_username
	[[ -z "${del_server_username}" ]] && echo -e "已取消..." && exit 1
	del_username=`cat -n ${server_conf}|grep '"username": "'"${del_server_username}"'"'|awk '{print $1}'`
	if [[ ! -z ${del_username} ]]; then
		del_username_min=$(expr $del_username - 1)
		del_username_max=$(expr $del_username + 7)
		del_username_max_text=$(sed -n "${del_username_max}p" ${server_conf})
		del_username_max_text_last=`echo ${del_username_max_text:((${#del_username_max_text} - 1))}`
		if [[ ${del_username_max_text_last} != "," ]]; then
			del_list_num=$(expr $del_username_min - 1)
			sed -i "${del_list_num}s/,//g" ${server_conf}
		fi
		sed -i "${del_username_min},${del_username_max}d" ${server_conf}
		echo -e "${Info} 节点删除成功 ${Green_font_prefix}[ 节点用户名: ${del_server_username} ]${Font_color_suffix} "
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Modify_ServerStatus_server_username(){
	List_ServerStatus_server
	echo -e "请输入要修改的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" manually_username
	[[ -z "${manually_username}" ]] && echo -e "已取消..." && exit 1
	Set_username_num=$(cat -n ${server_conf}|grep '"username": "'"${manually_username}"'"'|awk '{print $1}')
	if [[ ! -z ${Set_username_num} ]]; then
		Set_username
		Set_username_ch=$(cat ${server_conf}|grep '"username": "'"${username_s}"'"')
		[[ ! -z "${Set_username_ch}" ]] && echo -e "${Error} 用户名已被使用 !" && exit 1
		sed -i "${Set_username_num}"'s/"username": "'"${manually_username}"'"/"username": "'"${username_s}"'"/g' ${server_conf}
		echo -e "${Info} 修改成功 [ 原节点用户名: ${manually_username}, 新节点用户名: ${username_s} ]"
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Modify_ServerStatus_server_password(){
	List_ServerStatus_server
	echo -e "请输入要修改的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" manually_username
	[[ -z "${manually_username}" ]] && echo -e "已取消..." && exit 1
	Set_username_num=$(cat -n ${server_conf}|grep '"username": "'"${manually_username}"'"'|awk '{print $1}')
	if [[ ! -z ${Set_username_num} ]]; then
		Set_password
		Set_password_num_a=$(expr $Set_username_num + 1)
		Set_password_num_text=$(sed -n "${Set_password_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_password_num_a}"'s/"password": "'"${Set_password_num_text}"'"/"password": "'"${password_s}"'"/g' ${server_conf}
		echo -e "${Info} 修改成功 [ 原节点密码: ${Set_password_num_text}, 新节点密码: ${password_s} ]"
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Modify_ServerStatus_server_name(){
	List_ServerStatus_server
	echo -e "请输入要修改的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" manually_username
	[[ -z "${manually_username}" ]] && echo -e "已取消..." && exit 1
	Set_username_num=$(cat -n ${server_conf}|grep '"username": "'"${manually_username}"'"'|awk '{print $1}')
	if [[ ! -z ${Set_username_num} ]]; then
		Set_name
		Set_name_num_a=$(expr $Set_username_num + 2)
		Set_name_num_a_text=$(sed -n "${Set_name_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_name_num_a}"'s/"name": "'"${Set_name_num_a_text}"'"/"name": "'"${name_s}"'"/g' ${server_conf}
		echo -e "${Info} 修改成功 [ 原节点名称: ${Set_name_num_a_text}, 新节点名称: ${name_s} ]"
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Modify_ServerStatus_server_type(){
	List_ServerStatus_server
	echo -e "请输入要修改的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" manually_username
	[[ -z "${manually_username}" ]] && echo -e "已取消..." && exit 1
	Set_username_num=$(cat -n ${server_conf}|grep '"username": "'"${manually_username}"'"'|awk '{print $1}')
	if [[ ! -z ${Set_username_num} ]]; then
		Set_type
		Set_type_num_a=$(expr $Set_username_num + 3)
		Set_type_num_a_text=$(sed -n "${Set_type_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_type_num_a}"'s/"type": "'"${Set_type_num_a_text}"'"/"type": "'"${type_s}"'"/g' ${server_conf}
		echo -e "${Info} 修改成功 [ 原节点虚拟化: ${Set_type_num_a_text}, 新节点虚拟化: ${type_s} ]"
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Modify_ServerStatus_server_location(){
	List_ServerStatus_server
	echo -e "请输入要修改的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" manually_username
	[[ -z "${manually_username}" ]] && echo -e "已取消..." && exit 1
	Set_username_num=$(cat -n ${server_conf}|grep '"username": "'"${manually_username}"'"'|awk '{print $1}')
	if [[ ! -z ${Set_username_num} ]]; then
		Set_location
		Set_location_num_a=$(expr $Set_username_num + 5)
		Set_location_num_a_text=$(sed -n "${Set_location_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_location_num_a}"'s/"location": "'"${Set_location_num_a_text}"'"/"location": "'"${location_s}"'"/g' ${server_conf}
		echo -e "${Info} 修改成功 [ 原节点位置: ${Set_location_num_a_text}, 新节点位置: ${location_s} ]"
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Modify_ServerStatus_server_all(){
	List_ServerStatus_server
	echo -e "请输入要修改的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" manually_username
	[[ -z "${manually_username}" ]] && echo -e "已取消..." && exit 1
	Set_username_num=$(cat -n ${server_conf}|grep '"username": "'"${manually_username}"'"'|awk '{print $1}')
	if [[ ! -z ${Set_username_num} ]]; then
		Set_username
		Set_password
		Set_name
		Set_type
		Set_location
		sed -i "${Set_username_num}"'s/"username": "'"${manually_username}"'"/"username": "'"${username_s}"'"/g' ${server_conf}
		Set_password_num_a=$(expr $Set_username_num + 1)
		Set_password_num_text=$(sed -n "${Set_password_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_password_num_a}"'s/"password": "'"${Set_password_num_text}"'"/"password": "'"${password_s}"'"/g' ${server_conf}
		Set_name_num_a=$(expr $Set_username_num + 2)
		Set_name_num_a_text=$(sed -n "${Set_name_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_name_num_a}"'s/"name": "'"${Set_name_num_a_text}"'"/"name": "'"${name_s}"'"/g' ${server_conf}
		Set_type_num_a=$(expr $Set_username_num + 3)
		Set_type_num_a_text=$(sed -n "${Set_type_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_type_num_a}"'s/"type": "'"${Set_type_num_a_text}"'"/"type": "'"${type_s}"'"/g' ${server_conf}
		Set_location_num_a=$(expr $Set_username_num + 5)
		Set_location_num_a_text=$(sed -n "${Set_location_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		sed -i "${Set_location_num_a}"'s/"location": "'"${Set_location_num_a_text}"'"/"location": "'"${location_s}"'"/g' ${server_conf}
		echo -e "${Info} 修改成功。"
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Modify_ServerStatus_server_disabled(){
	List_ServerStatus_server
	echo -e "请输入要修改的节点用户名"
	stty erase '^H' && read -p "(默认: 取消):" manually_username
	[[ -z "${manually_username}" ]] && echo -e "已取消..." && exit 1
	Set_username_num=$(cat -n ${server_conf}|grep '"username": "'"${manually_username}"'"'|awk '{print $1}')
	if [[ ! -z ${Set_username_num} ]]; then
		Set_disabled_num_a=$(expr $Set_username_num + 6)
		Set_disabled_num_a_text=$(sed -n "${Set_disabled_num_a}p" ${server_conf}|sed 's/\"//g;s/,//g'|awk -F ": " '{print $2}')
		if [[ ${Set_disabled_num_a_text} == "false" ]]; then
			disabled_s="true"
		else
			disabled_s="false"
		fi
		sed -i "${Set_disabled_num_a}"'s/"disabled": '"${Set_disabled_num_a_text}"'/"disabled": '"${disabled_s}"'/g' ${server_conf}
		echo -e "${Info} 修改成功 [ 原禁用状态: ${Set_disabled_num_a_text}, 新禁用状态: ${disabled_s} ]"
	else
		echo -e "${Error} 请输入正确的节点用户名 !" && exit 1
	fi
}
Set_ServerStatus_client(){
	check_installed_client_status
	Set_config_client
	Read_config_client
	Modify_config_client
	Restart_ServerStatus_client
}
Modify_config_client(){
	sed -i 's/SERVER = "'"${client_server}"'"/SERVER = "'"${server_s}"'"/g' ${client_file}
	sed -i 's/USER = "'"${client_user}"'"/USER = "'"${username_s}"'"/g' ${client_file}
	sed -i 's/PASSWORD = "'"${client_password}"'"/PASSWORD = "'"${password_s}"'"/g' ${client_file}
}
Install_jq(){
	if [[ ! -e ${jq_file} ]]; then
		if [[ ${bit} = "x86_64" ]]; then
			wget  "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64" -O ${jq_file}
		else
			wget  "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32" -O ${jq_file}
		fi
		[[ ! -e ${jq_file} ]] && echo -e "${Error} JQ解析器 下载失败，请检查 !" && exit 1
		chmod +x ${jq_file}
		echo -e "${Info} JQ解析器 安装完成，继续..." 
	else
		echo -e "${Info} JQ解析器 已安装，继续..."
	fi
}

Install_ServerStatus_server(){
	[[ -e "${server_file}" ]] && echo -e "${Error} 检测到 ServerStatus 服务端已安装 !" && exit 1
	Set_server "server"
	Set_server_port
	echo -e "${Info} 开始安装/配置 依赖..."
	Installation_dependency "server"
	Install_caddy
	echo -e "${Info} 开始下载/安装..."
	Download_Server_Status_server
	Install_jq
	echo -e "${Info} 开始下载/安装 服务脚本(init)..."
	Service_Server_Status_server
	echo -e "${Info} 开始写入 配置文件..."
	Write_server_config
	echo -e "${Info} 所有步骤 安装完毕，开始启动..."
	Start_ServerStatus_server
}
Install_ServerStatus_client(){
	[[ -e ${client_file} ]] && echo -e "${Error} 检测到 ServerStatus 客户端已安装 !" && exit 1
	echo -e "${Info} 开始设置 用户配置..."
	Set_config_client
	echo -e "${Info} 开始安装/配置 依赖..."
	Installation_dependency "client"
	echo -e "${Info} 开始下载/安装..."
	Download_Server_Status_client
	echo -e "${Info} 开始下载/安装 服务脚本(init)..."
	Service_Server_Status_client
	echo -e "${Info} 开始写入 配置..."
	Read_config_client
	Modify_config_client
	echo -e "${Info} 所有步骤 安装完毕，开始启动..."
	Start_ServerStatus_client
}

Start_ServerStatus_server(){
	check_installed_server_status
	check_pid_server
	[[ ! -z ${PID} ]] && echo -e "${Error} ServerStatus 正在运行，请检查 !" && exit 1
	/etc/init.d/status-server start
}
Stop_ServerStatus_server(){
	check_installed_server_status
	check_pid_server
	[[ -z ${PID} ]] && echo -e "${Error} ServerStatus 没有运行，请检查 !" && exit 1
	/etc/init.d/status-server stop
}
Restart_ServerStatus_server(){
	check_installed_server_status
	check_pid_server
	[[ ! -z ${PID} ]] && /etc/init.d/status-server stop
	/etc/init.d/status-server start
}
Uninstall_ServerStatus_server(){
	check_installed_server_status
	echo "确定要卸载 ServerStatus 服务端(如果安装了客户端 不会一起删除) ? [y/N]"
	echo
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
		check_pid_server
		[[ ! -z $PID ]] && kill -9 ${PID}
		Del_iptables
		if [[ -e "${client_file}" ]]; then
			mv "${client_file}" "/usr/local/status-client.py"
			rm -rf "${file}"
			mkdir "${file}"
			mv "/usr/local/status-client.py" "${client_file}"
		else
			rm -rf "${file}"
		fi
		rm -rf "/etc/init.d/status-server"
		/etc/init.d/caddy stop
		if [[ ${release} = "centos" ]]; then
			chkconfig --del status-server
		else
			update-rc.d -f status-server remove
		fi
		echo && echo "ServerStatus 卸载完成 !" && echo
	else
		echo && echo "卸载已取消..." && echo
	fi
}
Start_ServerStatus_client(){
	check_installed_client_status
	check_pid_client
	[[ ! -z ${PID} ]] && echo -e "${Error} ServerStatus 正在运行，请检查 !" && exit 1
	/etc/init.d/status-client start
}
Stop_ServerStatus_client(){
	check_installed_client_status
	check_pid_client
	[[ -z ${PID} ]] && echo -e "${Error} ServerStatus 没有运行，请检查 !" && exit 1
	/etc/init.d/status-client stop
}
Restart_ServerStatus_client(){
	check_installed_client_status
	check_pid_client
	[[ ! -z ${PID} ]] && /etc/init.d/status-client stop
	/etc/init.d/status-client start
}
Uninstall_ServerStatus_client(){
	check_installed_client_status
	echo "确定要卸载 ServerStatus 客户端 ? [y/N]"
	echo
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
		check_pid_client
		[[ ! -z $PID ]] && kill -9 ${PID}
		Del_iptables
		if [[ -e "${server_file}" ]]; then
			rm -rf ${client_file}
		else
			rm -rf ${file}
		fi
		rm -rf /etc/init.d/status-client
		if [[ ${release} = "centos" ]]; then
			chkconfig --del status-client
		else
			update-rc.d -f status-client remove
		fi
		echo && echo "ServerStatus 卸载完成 !" && echo
	else
		echo && echo "卸载已取消..." && echo
	fi
}

echo -e "   ServerStatus 一键安装管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}

  ${Green_font_prefix}1.${Font_color_suffix} 安装 服务端
  ${Green_font_prefix}2.${Font_color_suffix} 安装 客户端
  ${Green_font_prefix}3.${Font_color_suffix} 一键 卸载
  ================================
  ${Green_font_prefix}4.${Font_color_suffix} 启动 服务端
  ${Green_font_prefix}5.${Font_color_suffix} 停止 服务端
  ${Green_font_prefix}6.${Font_color_suffix} 重启 服务端
   ================================
  ${Green_font_prefix}7.${Font_color_suffix} 启动 服务端
  ${Green_font_prefix}8.${Font_color_suffix} 停止 服务端
  ${Green_font_prefix}9.${Font_color_suffix} 重启 服务端
   ================================
  ${Green_font_prefix}10.${Font_color_suffix} 启动 客户端
  ${Green_font_prefix}11.${Font_color_suffix} 停止 客户端
  ${Green_font_prefix}12.${Font_color_suffix} 重启 客户端
   ================================"
   if [[ -e ${server_file} ]]; then
	check_pid_server
	if [[ ! -z "${PID}" ]]; then
		echo -e " 当前状态: 服务端 ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
	else
		echo -e " 当前状态: 服务端 ${Green_font_prefix}已安装${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
	fi
else
	echo -e " 当前状态: 服务端 ${Red_font_prefix}未安装${Font_color_suffix}"
fi
if [[ -e ${client_file} ]]; then
	check_pid_client
	if [[ ! -z "${PID}" ]]; then
		echo -e " 当前状态: 客户端 ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
	else
		echo -e " 当前状态: 客户端 ${Green_font_prefix}已安装${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
	fi
else
	echo -e " 当前状态: 客户端 ${Red_font_prefix}未安装${Font_color_suffix}"
fi
	echo "(默认: 取消):"
	read Xz_main
	[[ -z "${Xz_main}" ]] && echo "已取消..." && exit 1
	if [[ ${Xz_main} == "1" ]]; then
		Install_openssl
	elif [[ ${Xz_main} == "2" ]]; then
		Generate_key
	elif [[ ${Xz_main} == "3" ]]; then
		Download_key
	elif [[ ${Xz_main} == "4" ]]; then
		Upload_key
	elif [[ ${Xz_main} == "5" ]]; then
		modify_sshd_config
	elif [[ ${Xz_main} == "6" ]]; then
		restart_sshd
	elif [[ ${Xz_main} == "7" ]]; then
		close_passwd
	elif [[ ${Xz_main} == "3" ]]; then
		Download_key
	elif [[ ${Xz_main} == "4" ]]; then
		Upload_key
	elif [[ ${Xz_main} == "5" ]]; then
		modify_sshd_config
	elif [[ ${Xz_main} == "6" ]]; then
		restart_sshd
	elif [[ ${Xz_main} == "7" ]]; then
		close_passwd
	else
		echo -e "${Error} 请输入正确的选项" && exit 1
	fi






























cp -r ServerStatus/web/* /home/wwwroot/default
./sergate --config=config.json --web-dir=/home/wwwroot/default   

vim client-linux.py
python client-linux.py

### for Centos：
 yum -y install epel-release
 yum -y install python-pip
 yum clean all
 yum -y install gcc
 yum -y install python-devel
 pip install psutil
### for Ubuntu/Debian:
 root
apt-get -y install python-setuptools python-dev build-essential
apt-get -y install python-pip
pip install psutil

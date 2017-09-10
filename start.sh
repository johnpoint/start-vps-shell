#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 2.0.3
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#=================================================

sh_ver=2.0.3
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
 #Install_status
 Install_status(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/status.sh && chmod +x status.sh
 bash status.sh s
 }
 #Install_v2ray
 Install_v2ray(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/v2ray.sh && chmod +x v2ray.sh && ./v2ray.sh
 }
 #Install_sync
 Install_sync(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/sync.sh && chmod +x sync.sh && ./sync.sh
 }
 #Install_ytb_dl
 Install_ytb_dl(){
 cd ~
 wget https://yt-dl.org/downloads/2016.07.13/youtube-dl -O /usr/local/bin/youtube-dl
 chmod a+rx /usr/local/bin/youtube-dl
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
	elif [[ ${install_num} == "9" ]]; then
		Install_wordpress
	else
		echo -e "${Error} 请输入正确的数字 [1-9]" && exit 1
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


 if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  VPS一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 软件
  ${Green_font_prefix}2.${Font_color_suffix} 修改 密码
  ${Green_font_prefix}3.${Font_color_suffix} 查看 系统信息
  ${Green_font_prefix}4.${Font_color_suffix} 更改 系统为密钥登陆
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
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
esac
fi

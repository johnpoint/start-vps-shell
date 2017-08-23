#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin 

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
 }
 
 #sshd_config
 sshd_config(){
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
 service ssh restart
 service sshd restart
 echo '请使用key登陆测试是否成功'
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 #menu
if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
else
	echo -e "  更换登陆方式为密钥 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  ${Green_font_prefix}1.${Font_color_suffix} 安装 openssl
  ${Green_font_prefix}2.${Font_color_suffix} 生成 key
  ${Green_font_prefix}3.${Font_color_suffix} 取回 私钥
  ${Green_font_prefix}4.${Font_color_suffix} 上传 key（多服务端单key选此项）
  ${Green_font_prefix}5.${Font_color_suffix} 修改 sshd_config文件上传
  ${Green_font_prefix}6.${Font_color_suffix} 重启 ssh服务
  
 "
	menu_status
	echo && stty erase '^H' && read -p "请输入数字 [1-5]：" num
case "$num" in
	1)
	Install_openssl
	;;
	2)
	Generate_key
	;;
	3)
	Download_key
	;;
	4)
	Upload_key
	;;
	5)
	modify_sshd_config
	;;
	6)
	restart_sshd
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
esac
fi
 
 #echo
 echo 'service sshd restart'
 echo 'END'


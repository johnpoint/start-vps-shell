#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 1.0.1
#	Blog: www.lvcshu.club
#	Author: johnpoint
#	Mail: hi@lvcshu.club
#=================================================

clear

Base_in(){
echo -e "请输入要进行base64编码的字符串"
read r
echo "${r}" | base64 -i
}

Base_out(){
echo -e "请输入要进行base64解码的字符串"
read r
echo "${r}" | base64 -d
}

echo "base64脚本工具
1.解码 2.编码"
read i
if [[ ${i} = "1" ]]; then
	Base_out
elif [[ ${i} = "2" ]]; then
	Base_in
else
	echo "无效的输入(请输入1或2)"
	exit 0
fi

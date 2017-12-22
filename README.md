>本文最后更新于 2017-12-20 11:18 
>本文可能有些内容已失效，请与作者联系
>>[telegram](https://t.me/johnpoint)

本作品采用[知识共享署名-相同方式共享 4.0 国际许可协议](http://creativecommons.org/licenses/by-sa/4.0/)进行许可。

# 前言 #

在我接触到VPS这个神奇的东西之后，就一发不可收拾，然后我发现以我的水平VPS总会出现各种各样的问题。

然后，我还很懒~(*T▽T*)

于是我github上的**第一个re-po**应运而生：

~~闪亮登场~~

[start-vps-shell](https://www.github.com/johnpoint/start-vps-shell)

# 获取&使用 #

## 获取 ##

```
wget -N --no-check-certificate https://github.com/johnpoint/start-vps-shell/raw/master/start.sh && chmod +x start.sh && ./start.sh
```

备用下载：(有至多24小时延迟!)

```
wget -N --no-check-certificate https://yun.lvcshu.club/GitHub/start-vps-shell/start.sh && chmod +x start.sh && ./start.sh
```

### 特殊的 ###

有些系统精简得太厉害，连wget都没有安装，用这个：

```
curl https://github.com/johnpoint/start-vps-shell/raw/master/re-start.sh |bash
```

~~我是不是很贴心呀~~

## 使用 ##

首先，当你执行了上面的命令后应该已经弹出了**主菜单**，然后就可以按照*中文提示*来进行操作了~  ╮( •́ω•̀ )╭

# 功能详析 #

接下来的内容就是解释脚本内容的步骤~~我知道你们看源码能看懂~~

## 功能一：安装软件（应该是 ##

### 安装依赖 ###

- wget
- lrzsz  （Xshell 转机神器）
- git （这个应该不用说了）
- unzip （解压缩）

### 安装软件 ###

- ssr (一款优秀的代理软件) 来自：[toyo](https://doub.io)
- 逗比云监控 （多vps党必备）来自：[toyo](https://doub.io)
- ~~v2ray （可定制化代理软件）~~[目前无法安装]
- sync （便利地建立私人云盘，大硬盘vps福利）
- YouTube-dl （命令行下载YouTube视频）
- EFB_bot （telegram-微信互联，慎用可能会造成微信网页版被封禁）
- 『原创』WordPress （自助安装博客必备环境）
- GoFlyway （新的代理软件）来自：[toyo](https://doub.io)
- 『原创』ExpressBot （telegram查询快递bot-benny出品）
- bbr （秋水逸冰一键安装bbr脚本）

## 功能二：系统相关操作 ##

- 修改密码 ~~老是觉得有点多此一举~~
- 『原创』修改登录方式为密匙登录
- 查看vps详细参数 （来自：oooldking和teddysun）

## 功能三：脚本自动更新 ##

代码来自toyo大佬的[博客](https://doub.io)


## 项目结构树 ##

```
start-vps-shell
    │
    ├── shell
    │     ├── EFB.sh
    │     ├── install.sh (已弃用，留作备份)
    │     ├── ssh_key.sh(已弃用，留作备份)
    │     ├── sync.sh
    │     ├── v2ray.sh
    │     ├── wordpress.sh
    │     ├── superbench.sh
    │
    │
    ├── start.sh
    ├── re-start.sh
    ├── README.md
    ├── LICENSE
```

# TODO #

- [ ] 完善ip检测
- [x] 整理re-po
- [ ] 增加 v2ray 安装
- [x] 增加VPS具体参数检测 - superbech.sh
- [ ] 添加检查ssh日志功能
- [x] 添加检查bbr是否安装功能
- [x] 精简安装语句
- [x] 增加检测ip地址
- [ ] 添加软件重复安装判定
- [x] 菜单美化

# 总结 #

真的是懒人/小白必备，~~我就是懒人~~

# License #

[GPL v2](https://github.com/johnpoint/start-vps-shell/blob/master/LICENSE)
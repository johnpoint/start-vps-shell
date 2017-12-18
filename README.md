# start-vps-shell #

## 前言 ##

写这个就是因为懒嘛～这样重装vps以后就不用重新一个个的安装（

## 安装&使用 ##

### 安装 ###

```
wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh && ./start.sh
```

备用下载：

```
wget -N --no-check-certificate https://yun.lvcshu.club/GitHub/start-vps-shell/start.sh && chmod +x start.sh && ./start.sh
```

### 特殊的 ###

有些系统精简得太厉害，连wget都没有安装，用这个：

```
curl https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/re-start.sh |bash
```

### 使用 ###

这个脚本可是中文的，不会用我也帮不了你了...

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

## To Do ##
- [x] 整理re-po
- [ ] 增加 v2ray 安装
- [x] 增加VPS具体参数检测 - superbech.sh
- [ ] 添加检查ssh日志功能
- [ ] 添加检查bbr/net-speed是否安装功能
- [x] 精简安装语句
- [x] 增加检测ip地址

## 备注 ##

有什么好主意可以联系我哦~！⊙∀⊙！~

Telegram:[@johnpoint](https://t.me/johnpoint)

Gmail:<jahanngauss414@gmail.com>

## License ##
GPL v2

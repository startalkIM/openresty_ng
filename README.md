# 概述

这个目录介绍 startalk 的 openresty 相关配置。startalk 利用 openresty 提供了若干基于 http/https 的服务，在启动整个系统之前需要恰当配置 openresty。

# or 服务

Startalk 内置了一些 or (运行 lua-jit 的) 服务，用于 IM http 请求负载均衡的服务，完整体系架构可参考[ejabberd](https://github.com/qunarcorp/ejabberd-open)

## 简介

* 所有 Web 相关软件都安装到 ``${STARTALK_WEB_SERVICE}`` 下面，缺省是 ``/startalk`` 目录。
* 安装用户和用户组是：startalk:startalk，可能需要系统 startalk 用户有 sudo 权限
* startalk 用户家目录下有 download 文件夹，所有文件会下载到该文件夹下
* 数据库用户名初始密码是 ejabberd:123456，服务地址是：127.0.0.1 请自行修改
* redis 初始密码是：123456，服务地址是：127.0.0.1 请自行修改

## 安装

### 新建安装目录

```
# sudo mkdir /startalk
# sudo chown startalk:startalk /startalk
```

### 编译安装 openresty
这一步是安装开源 openresty 软件，以 startalk 用户下载软件并且编译安装之，如果系统已有 openresty 软件包（rpm、deb等），则可以忽略这一步。
但是要关注 openresty 的启动用户，详见 ``/usr/local/openresty/nginx/conf/nginx.conf`` 配置文件。

```
# cd /home/startalk/download
# wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
# tar -zxvf openresty-1.13.6.2.tar.gz
# ./configure --prefix=/startalk/openresty
# make
# make install
```
### or 服务安装

```
# cd /home/startalk/download
# git clone https://github.com/startalkIM/openresty_ng.git
# cd openresty_ng
# cp -rf conf /startalk/openresty/nginx
# cp -rf startalk_lua /startalk/openresty/nginx

```

## 配置

### or 服务配置修改

#### location的配置
```
/startalk/openresty/nginx/conf/conf.d/startalk/or.server.location.package.qtapi.conf
```
#### upstream的配置
```
/startalk/openresty/nginx/conf/conf.d/startalkupstreams/st.upstream.conf
```
#### redis连接地址配置
```
/startalk/openresty/nginx/startalk_lua/checks/qim/startalkredis.lua
```

## or操作

启动：
```
/startalk/openresty/nginx/sbin/nginx
```
停止：

```
/startalk/openresty/nginx/sbin/nginx -s stop
```

## or升级

```
$ cd /startalk/download/openresty_ng
$ git pull
$ cp -rf conf /startalk/openresty/nginx
$ cp -rf startalk_lua /startalk/openresty/nginx
$ sudo /startalk/openresty/nginx/sbin/nginx -s reload
```

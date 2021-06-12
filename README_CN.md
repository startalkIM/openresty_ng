
# 概述

startalk 需要启动一些基于 http/https 的服务，这些服务是通过开源软件 openresty 提供的接口支持的。本项目描述了如何安装配置 startalk 的 openresty。


# 术语和缺省

* 所有 Web 相关软件都安装到 ``${STARTALK_OPENRESTY}`` 下面，缺省是 ``/usr/local/openresty`` 目录。
* 缺省安装用户和用户组是：``startalk:startalk``，可能需要系统 ``startalk`` 用户有 ``sudo`` 权限，熟悉系统的用户也可以用自己的普通用户，比如 ``nobody``
* ``startalk`` 用户家目录下有 ``download`` 文件夹，所有源代码和配置文件会下载到该文件夹下
* 数据库用户名初始密码是 ``ejabberd:123456``，数据库服务器缺省地址是：``127.0.0.1`` 请自行修改
* ``redis`` 初始密码是：``123456``，服务地址是：``127.0.0.1`` 请自行修改

# 本项目各目录说明

* conf: startalk 用到的 openresty 的主要配置文件
* startalk_lua : startalk 的 openresty 使用的一些 lua 代码，用于对请求做动态变更
* tools：一些测试用工具

# startalk or 服务

Startalk 内置了一些 or (运行 lua-jit 的) 服务，用于 IM http 请求负载均衡的服务，完整体系架构可参考[ejabberd](https://github.com/startalkIM/ejabberd)

# 安装 openresty  

## 设定Openresty安装位置变量, 使用/usr/local/openresty作为案例
```
$ export STARTALK_OPENRESTY=/usr/local/openresty 
```

## 新建安装目录

```
$ sudo mkdir -p ${STARTALK_OPENRESTY}
$ sudo chown startalk:startalk ${STARTALK_OPENRESTY}
```

## 编译安装 openresty

这一步是安装开源 openresty 软件，以 startalk 用户下载软件并且编译安装之，如果系统已有 openresty 软件包（rpm、deb等），则可以忽略这一步。
但是要关注 openresty 的启动用户和缺省安装位置，大多数缺省安装包的 ``openresty`` 的配置文件在 ``/usr/local/openresty/nginx/conf/nginx.conf`` 。
我们强烈建议使用 [OpenResty 官方网站](https://openresty.org) 上的预编译包安装 ``openresty``，而不要选择手工编译，如果您已经用预编译包安装好了 ``openresty``，请忽略本节剩下的内容。

请注意设置下面 ``${STARTALK_OPENRESTY}`` 变量或者使用上面的缺省替换之。

```
$ cd /home/startalk/download
$ wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
$ tar -zxvf openresty-1.13.6.2.tar.gz
$ ./configure --prefix=${STARTALK_OPENRESTY}
$ make
$ sudo make install
```

# 安装 startalk or 服务

```
$ cd /home/startalk/download
$ git clone https://github.com/startalkIM/openresty_ng.git
$ cd openresty_ng
$ sudo cp -rf conf ${STARTALK_OPENRESTY}/nginx
$ sudo cp -rf startalk_lua ${STARTALK_OPENRESTY}/nginx

```
请注意将 ``${STARTALK_OPENRESTY}/nginx/conf/startalk-nginx.conf-sample`` 的内容修改到 ``${STARTALK_OPENRESTY}/nginx/conf/nginx.conf`` 中，
如果是彻底偷懒的话则用本项目的 ``conf/startalk-nginx.conf-sample`` 文件覆盖 ``${STARTALK_OPENRESTY}/nginx/conf/nginx.conf``：

```
$ sudo cp -rf conf/startalk-nginx.conf-sample ${STARTALK_OPENRESTY}/nginx/conf/nginx.conf
```
请注意执行上面这条命令之前，你必须知道自己在干什么。

# 配置 Openresty

## or 服务配置修改

### location的配置
```
${STARTALK_OPENRESTY}/nginx/conf/conf.d/startalk/or.server.location.package.qtapi.conf
```
### upstream的配置
```
${STARTALK_OPENRESTY}/nginx/conf/conf.d/startalkupstream/st.upstream.conf
```
### redis连接地址配置
```
${STARTALK_OPENRESTY}/nginx/startalk_lua/checks/qim/startalkredis.lua
```

## or操作

请注意我们使用了  `-p` 参数与 `nginx.conf.sample` 内的 `lua_package_path` 配合。

启动：
```
${STARTALK_OPENRESTY}/nginx/sbin/nginx -p ${STARTALK_OPENRESTY}/nginx -c ${STARTALK_OPENRESTY}/nginx/conf/nginx.conf
```

停止：

```
${STARTALK_OPENRESTY}/nginx/sbin/nginx -p ${STARTALK_OPENRESTY}/nginx -c ${STARTALK_OPENRESTY}/nginx/conf/nginx.conf -s stop
```
重载配置：

```
${STARTALK_OPENRESTY}/nginx/sbin/nginx -p ${STARTALK_OPENRESTY}/nginx -c ${STARTALK_OPENRESTY}/nginx/conf/nginx.conf -s reload
```


## or升级

```
$ cd /startalk/download/openresty_ng
$ git pull
$ sudo cp -rf conf /startalk/openresty/nginx
$ sudo cp -rf startalk_lua /startalk/openresty/nginx
$ sudo /startalk/openresty/nginx/sbin/nginx -s reload
```

# or

or服务，用于IM http请求负载均衡的服务，完整体系架构可参考[ejabberd](https://github.com/qunarcorp/ejabberd-open)

## 前提
+ 所有项目都安装到/startalk下面
+ 安装用户和用户组是：startalk:startalk，要保证startalk用户有sudo权限
+ 家目录下有download文件夹，所有文件会下载到该文件夹下
+ 数据库用户名密码是ejabberd:123456，服务地址是：127.0.0.1
+ redis密码是：123456，服务地址是：127.0.0.1

## 安装

```
新建安装目录
# sudo mkdir /startalk
# sudo chown startalk:startalk /startalk

openresry安装
# cd /home/startalk/download
# wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
# tar -zxvf openresty-1.13.6.2.tar.gz
# ./configure --prefix=/startalk/openresty
# make
# make install

or安装
# cd /home/startalk/download
# cd or_open
# cp -rf conf /startalk/openresty/nginx
# cp -rf lua_app /startalk/openresty/nginx

```

## 配置

```
or配置修改

location的配置
/startalk/openresty/nginx/conf/conf.d/subconf/or.server.location.package.qtapi.conf

upstream的配置
/startalk/openresty/nginx/conf/conf.d/upstreams/qt.qunar.com.upstream.conf

redis连接地址配置
/startalk/openresty/nginx/lua_app/checks/qim/qtalkredis.lua
```

## or操作

```
启动：/startalk/openresty/nginx/sbin/nginx
停止：/startalk/openresty/nginx/sbin/nginx -s stop
```

## or升级

```
$ cd /startalk/download/or_open
$ git pull
$ cp -rf conf /startalk/openresty/nginx
$ cp -rf lua_app /startalk/openresty/nginx
$ sudo /startalk/openresty/nginx/sbin/nginx -s reload
```

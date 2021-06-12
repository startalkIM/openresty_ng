# Overview

startalk needs to start some http/https based services that are supported through an interface provided by the open source software openresty. This project describes how to install and configure openresty for startalk.


# Terminology and defaults

* All web-related software is installed under ``${STARTALK_OPENRESTY}``, the default is the ``/usr/local/openresty`` directory.
* The default installation user and user group is: ``startalk:startalk``, which may require the system ``startalk`` user to have ``sudo`` privileges, or users familiar with the system can use their own normal user, such as ``nobody``
* ``startalk`` user has a ``download`` folder in his home directory, all source code and configuration files will be downloaded to this folder
* The initial password for the database user name is ``ejabberd:123456`` and the default address of the database server is ``127.0.0.1`` Please change it yourself
* ``redis`` initial password is: ``123456``, the service address is: ``127.0.0.1`` Please change it yourself

# Description of each directory in this project


* conf: the main configuration file of openresty used by startalk
* startalk_lua : some lua code used by startalk's openresty, used to make dynamic changes to requests
* tools: some tools for testing

# startalk or services

Startalk has some built-in or (running lua-jit) services for IM http request load balancing, see [ejabberd](https://github.com/startalkIM/ejabberd) for the full architecture

# Install openresty  

## Set Openresty location, take /usr/local/openresty as example
```
$ export STARTALK_OPENRESTY=/usr/local/openresty
```

## Create a new installation directory

```
$ sudo mkdir -p ${STARTALK_OPENRESTY}
$ sudo chown startalk:startalk ${STARTALK_OPENRESTY}
```

## Compile and install openresty

This step is to install the openresty software, download the software as a startalk user and compile and install it, if the system already has openresty packages (rpm, deb, etc.), you can ignore this step.

However, you should pay attention to openresty startup user and default installation location, most of the default installation package ``openresty`` configuration file is in ``/usr/local/openresty/nginx/conf/nginx.conf``.


Please note that the following ``${STARTALK_OPENRESTY}`` variable is set or replaced with the default above.
Do not build your own openresty if you are no familiare with Linux and/or open source software. We strongly recommend to use prebuild openresty package on [OpenResty Web Site](https://openresty.org) instead. Omit below if you've installed openresty via prebuild package.

```
$ cd /home/startalk/download
$ wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
$ tar -zxvf openresty-1.13.6.2.tar.gz
$ . /configure --prefix=${STARTALK_OPENRESTY}
$ make
$ sudo make install
```

# Install startalk or service


```
$ cd /home/startalk/download
$ git clone https://github.com/startalkIM/openresty_ng.git
$ cd openresty_ng
$ sudo cp -rf conf ${STARTALK_OPENRESTY}/nginx
$ sudo cp -rf startalk_lua ${STARTALK_OPENRESTY}/nginx

```
Please note that the contents of ``${STARTALK_OPENRESTY}/nginx/conf/startalk-nginx.conf-sample`` are modified to ``${STARTALK_OPENRESTY}/nginx/conf/nginx.conf``.
If you are completely lazy, overwrite ``${STARTALK_OPENRESTY}/nginx/conf/nginx.conf`` with the project's ``conf/startalk-nginx.conf-sample`` file.

```
$ sudo cp -rf conf/startalk-nginx.conf-sample ${STARTALK_OPENRESTY}/nginx/conf/nginx.conf
```
Please note that you must know what you are doing before you execute this command above.

## Configure Openresty

## or service configuration changes

### configuration of location
```
${STARTALK_OPENRESTY}/nginx/conf/conf.d/startalk/or.server.location.package.qtapi.conf
```
### upstream configuration
```
${STARTALK_OPENRESTY}/nginx/conf/conf.d/startalkupstream/st.upstream.conf
```
### redis connection address configuration
```
${STARTALK_OPENRESTY}/nginx/startalk_lua/checks/qim/startalkredis.lua
```

## or operations

Start.
```
${STARTALK_OPENRESTY}/nginx/sbin/nginx
```
Stop.

```
${STARTALK_OPENRESTY}/nginx/sbin/nginx -s stop
```

## or upgrade

```
$ cd /startalk/download/openresty_ng
$ git pull
$ sudo cp -rf conf /startalk/openresty/nginx
$ sudo cp -rf startalk_lua /startalk/openresty/nginx
$ sudo /startalk/openresty/nginx/sbin/nginx -s reload
```

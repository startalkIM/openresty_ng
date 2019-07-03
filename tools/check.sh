#!/bin/sh

# check redis port
echo "=============================================================="
result=`netstat -ntl | grep 6379`

if [[ -z $result ]];
then
    echo "error: redis port 6379 is not open"
else
    echo "success: redis port 6379 is open"
fi

# check postgres port
echo "=============================================================="
result=`netstat -ntl | grep 5432`

if [[ -z $result ]];
then
    echo "error: postgresql port 5432 is not open"
else
    echo "success: postgresql port 5432 is open"
fi

# check ejabberd port
echo "=============================================================="
result=`netstat -ntl | grep 5280`

if [[ -z $result ]];
then
    echo "error: ejabberdport 5280 is not open; to run with startalk: cd /startalk/ejabberd; ./sbin/ejabberdctl start"
else
    echo "success: ejabberd port 5280 is open"
fi

result=`netstat -ntl | grep 10050`

if [[ -z $result ]];
then
    echo "error: ejabberdport 10050 is not open; to run with startalk: cd /startalk/ejabberd; ./sbin/ejabberdctl start"
else
    echo "success: ejabberd port 10050 is open"
fi

result=`netstat -ntl | grep 5202`

if [[ -z $result ]];
then
    echo "error: ejabberd port 5202 is not open; to run with startalk: cd /startalk/ejabberd; ./sbin/ejabberdctl start"
else
    echo "success: ejabberd port 5202 is open"
fi

# check openresty port
echo "=============================================================="
result=`netstat -ntl | grep 8080`

if [[ -z $result ]];
then
    echo "error: openresty port 8080 is not open; to run with startalk: /startalk/openresty/nginx/sbin/nginx"
else
    echo "success: openresty port 8080 is open"
fi

# check im_http_service port
echo "=============================================================="
result=`netstat -ntl | grep 8081`

if [[ -z $result ]];
then
    echo "error: im_http_service port 8081 is not open; to run with startalk: cd /startalk/tomcat/im_http_service; ./bin/start.sh"
else
    echo "success: im_http_service port 8081 is open"
fi

# check qfproxy port
echo "=============================================================="
result=`netstat -ntl | grep 8082`

if [[ -z $result ]];
then
    echo "error: qfproxy port 8082 is not open; to run with startalk: cd /startalk/tomcat/qfproxy; ./bin/start.sh"
else
    echo "success: qfproxy port 8082 is open"
fi

# check push port
echo "=============================================================="
result=`netstat -ntl | grep 8083`

if [[ -z $result ]];
then
    echo "error: push_service port 8083 is not open; to run with startalk: cd /startalk/tomcat/push_service; ./bin/start.sh"
else
    echo "success: push_service port 8083 is open"
fi

# check qtalk_search port
echo "=============================================================="
result=`netstat -ntl | grep 8884`

if [[ -z $result ]];
then
    echo "error: qtalk_search port 8884 is not open"
else
    echo "success: qtalk_search port 8884 is open"
fi

# check startalk_found port
echo "=============================================================="
result=`netstat -ntl | grep 8085`

if [[ -z $result ]];
then
    echo "error: startalk_found port 8085 is not open; to run with startalk: cd /startalk/tomcat/qtalk_background_management; ./bin/start.sh(开源版本请忽略)"
else
    echo "success: startalk_found port 8085 is open"
fi

# check database setting
echo "=============================================================="
echo "postgresql data is:"
psql -U postgres -d ejabberd -h 127.0.0.1 -c "select * from host_info;"
psql -U postgres -d ejabberd -h 127.0.0.1 -c "select host_id, user_id from host_users;"
psql -U postgres -d ejabberd -h 127.0.0.1 -c "select password, pwd_salt from host_users where host_id in (select id from host_info where host = 'qtalk.test.org') and user_id = 'admin' and hire_flag = '1' and frozen_flag='0';"

# check nav.json
echo "=============================================================="
result=`curl -s 'http://ip:8080/newapi/nck/qtalk_nav.qunar'`

echo "the nav result is:"
echo $result

# check ejabberd host setting
echo "=============================================================="
echo "ejabberd hosts setting is:"
grep -A 1 "^hosts:" /startalk/ejabberd/etc/ejabberd/ejabberd.yml

result=`echo " " | telnet ip 5202 2>/dev/null| grep "Connected to" | wc -l`
if [ $result -eq 1 ];then
      echo "ip的5202端口已开启访问"
else 
      echo "ip的5202端口未开启外网访问，请开启该端口访问或者关掉防火墙"
fi

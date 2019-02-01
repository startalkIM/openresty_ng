#!/bin/sh

mkdir -p /home/liufan/download/backup/ejabberd
mkdir -p /home/liufan/download/backup/qtalk_cowboy
mkdir -p /home/liufan/download/backup/qfproxy
mkdir -p /home/liufan/download/backup/push_service
mkdir -p /home/liufan/download/backup/im_http_service

datestr="$(date +%Y-%-m-%-d-%H:%m:%S)"

cp -rf /startalk/tomcat/im_http_service/webapps/im_http_service /home/liufan/download/backup/im_http_service/$datestr
cp -rf /startalk/tomcat/push_service/webapps/push_service /home/liufan/download/backup/push_service/$datestr
cp -rf /startalk/tomcat/qfproxy/webapps/qfproxy /home/liufan/download/backup/qfproxy/$datestr
cp -rf /startalk/qtalk_cowboy_open/config /home/liufan/download/backup/qtalk_cowboy/$datestr
cp -rf /startalk/ejabberd/etc/ejabberd /home/liufan/download/backup/ejabberd/$datestr

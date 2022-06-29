#!/bin/bash
#name: restart.sh
#desc: 重启脚本
#date: 2021/8/10
#author: wone

#当前脚本所在目录的路径
current_path=`pwd`

#导入application.sh
. $current_path/application.sh


#重启方法
function restart(){
	is_running           #先获取pid
	if [ $? -eq '0' ]
    then    #返回0，表示没有运行，那么我就直接启动
			echo "${app_name} is not running, and now it will be started"
			start              #调用启动方法
			is_running	       #更新pid
			echo "${app_name} is running at pid: ${pid}"   #提示启动成功
		else
			stop               #程序在运行，先stop，再start
			start
			is_running 				 #更新pid
			echo "${app_name} has benn restarted running at pid: ${pid}"
		fi
}





####################程序入口##################
restart
	

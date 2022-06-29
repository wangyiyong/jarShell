#!/bin/bash
#name: start.sh
#desc: 启动jar包
#date：2021/8/10
#author：wone

#当前脚本所在目录的路径
current_path=`pwd`

#导入application.sh
. $current_path/application.sh


#启动程序
function start_app(){
	start
	is_running               #更新pid
	if [ $? -eq '1' ]; then  #如果启动成功
		echo "${app_name} is started at pid: ${pid}"
	else                     #启动失败
			if [ -z $pid ]
     then	#如果pid为空，说明启动失败
         echo "${app_name} started failed"
			else
					echo "${app_name} is already running at pid: ${pid}"  #程序已经在运行
			fi
	fi
}

##############脚本程序入口############
start_app

#!/bin/bash
#name: application.sh
#desc: 应用相关信息
#dete: 2021/8/10
#author: wone

#当前脚本所在文件夹路径
current_path=`pwd`

#应用名称
app_name=''

#应用位置
app_path=''

#应用运行的pid
pid=''

#在当前目录查找所有jar包列表，并让用户选择需要操作的jar
function findJar(){
    files=$(ls *.jar)
    index=0
    echo "----请选择需要操作的jar文件----"
	for mFile in $files
	do
	 fileArr[$index]=$mFile
	 temPid=`ps -ef|grep ${mFile}|grep -v grep|awk '{print $2}'` #获取jar包运行的pid
	 if [ -z $temPid ] ;then  #如果pid的长度为空，说明没有在运行
			echo "【${index}】${mFile}-->stop"
	 else
			echo "【${index}】${mFile}-->running"
	 fi
	 let index+=1
	done
	echo "【x】退出"
    read sel
    if [ ! $sel ];then
		sel=0
    fi	
    if [ $sel == 'x' ] || [ $sel == 'X' ]; then
    	exit
    fi

	if [ $sel -ge 0 ] && [ $sel -lt ${#fileArr[*]} ]; then
	    app_name=${fileArr[$sel]}
	    echo "选择了：$app_name"
	    app_path=$(pwd)/$app_name
	else
	    echo "error:请选择0到${#fileArr[*]}之间的数字！"
	    findJar
	fi
}



#判断jar包是否在运行
#jar如果在运行返回1，否则返回0
function is_running(){
	pid=`ps -ef|grep ${app_name}|grep -v grep|awk '{print $2}'` #获取jar包运行的pid
	if [ -z $pid ] ;then  #如果pid的长度为空，说明没有在运行
			return 0
	else
			return 1
	fi
}

#启动jar包,启动成功返回1，否则返回0
function start(){
	#先判断jar有没有在运行
	is_running
	if [ $? -eq "0" ]; then #没有运行，就使用nohup命令启动
		nohup java -jar $app_path > /dev/null 2>&1 &
		is_running
		return 1
	else
		return 0
	fi
}

#停止jar包，停止成功返回1，否则返回0
function stop(){
	#先判断jar是否在运行
	is_running
	if [ $? -eq '0' ]; then
		return 0  #jar没有运行，停止失败
	else
		kill -9 $pid  #jar在运行，使用kill命令停止
		return 1
	fi
}


findJar


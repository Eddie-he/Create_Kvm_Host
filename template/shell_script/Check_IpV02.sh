#!/bin/bash
#------------------------------- 
#Version        0.2 
#Filename:      Check_IpV02.sh 
#Date:          2016.08.22
#Email:         heshuangcai@hotmail.com 
#-------------------------------

echo "检查可用IP地址（100-150）"

function Check_Ip(){
    for i in {100..150}
      do
	ping -c 1 192.168.1.$i >/dev/null
	if [ $? -ne 0 ];then
            VIP="192.168.1.$i"	
            arr[$a]=$VIP
            echo ${arr[$a]}
	fi
    done
}
trap '{ echo "Hey, you pressed Ctrl-C.  Time to quit." ; exit 1; }' INT
echo "可以键入 Ctrl-C/退出IP检查$(basename $0)."
echo -e "可用IP地址如下：\n"
    Check_Ip
#logger -p notice "$(basename $0) - 用户终止可用IP地址检查！"


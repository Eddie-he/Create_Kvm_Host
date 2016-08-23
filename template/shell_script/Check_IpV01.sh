#!/bin/bash 
#------------------------------- 
#Version        0.1 
#Filename:      Check_IpV01.sh 
#Date:          2016.08.22
#Email:         heshuangcai@hotmail.com 
#------------------------------- 
# 
#定义变量 
NETWORK=$(ifconfig bridge0 | grep "inet" | awk '{print $2}'|head -n 1| awk -F"." '{print $1"."$2"."$3}') 
IPTEMP=$(mktemp) 
IPUP="/tmp/ipup.txt" 
IPDOWN="/tmp/ipdown.txt" 
if [ ! -f "$IPUP"  -a ! -f "$IPDOWN" ]; then  
        touch $IPUP $IPDOWN 
fi 
#扫描网络并分类输出IP 
echo "正在执行IP扫描,请稍候..." 
echo "" 
for ip in `seq 100 140` 
do 
        arping -I bridge0 -c 1 "$NETWORK".$ip > $IPTEMP 
        if [ $? -eq 0 ]; then 
                cat $IPTEMP | grep "reply" | awk '{print $4,$5}' >> $IPUP 
        else 
                cat $IPTEMP | head -n 1 | awk '{print $2}' >> $IPDOWN 
        fi 
done 
#将结果输出并清除临时文件 
clear 
echo  "正在使用的IP及MAC:" 
echo "" 
cat $IPUP 
echo "" 
echo "未使用的IP：" 
echo "" 
cat $IPDOWN 
echo "" 
rm -f $IPTEMP $IPUP $IPDOWN 

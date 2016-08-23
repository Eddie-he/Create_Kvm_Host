#!/bin/bash

#------------------------------- 
#Version        0.1 
#Filename:      Create_Kvm_01.sh 
#Date:          2016.08.22
#Email:         heshuangcai@hotmail.com 
#-------------------------------
UUID="<uuid>`uuidgen`</uuid>"
MAC=`echo -n 52:12:00; dd bs=1 count=3 if=/dev/random 2>/dev/null |hexdump -v -e '/1 ":%02X"'`

function Check_Ip(){
    for i in {100..104}
      do
	ping -c 3 192.168.1.$i >/dev/null
	if [ $? -ne 0 ];then
	VIP="192.168.1.$i"	
        arr[$a]=$VIP
        echo ${arr[$a]}
	fi
    done
}
#logger -p notice "$(basename $0) - 用户终止可用IP地址检查！"
function Doing(){
	for i in `seq 1 5`; do
            sleep 1
            echo -n "."
        done
}

function Create_Host(){
    echo "生成虚拟机磁盘....."
    cp -a /template/img/template.qcow2 /home/centos7.0-VM$y.qcow2
    cp -a /template/xml/template_qcow2.xml /etc/libvirt/qemu/centos7.0-VM$y.xml
    sed -i "s/centos7.0-VM1/centos7.0-VM$y/g" /etc/libvirt/qemu/centos7.0-VM$y.xml
    sed -i "s/file\=.*/file\=\'\/home\/centos7\.0-VM$y\.qcow2\'\/\>/g" /etc/libvirt/qemu/centos7.0-VM$y.xml
    ###########################vnc  port#######################
    #sed -i "s/5901/590$x/g" /etc/libvirt/qemu/centos7.0-VM$y.xml
    ############uuid######################################
    echo "修改虚拟机磁盘UUID和网卡MAC地址......"
    sed -i "/\<uuid/c \\${UUID}" /etc/libvirt/qemu/centos7.0-VM$y.xml
    #####################mac###################################
    
    sed -i "s/52:54:00:d4:59:47/$MAC/g" /etc/libvirt/qemu/centos7.0-VM$y.xml
    ##################define virsh ###########################
    echo "注册虚拟主机......"
    virsh define /etc/libvirt/qemu/centos7.0-VM$y.xml >>/tmp/vminstall.log 2>&1 
    logger -p notice "$(basename $0) - 注册虚拟主机到系统中。"
    ##########################change address| change hostname #########
}
function Change_Ip(){
    echo "更改虚拟主机静态IP配置文件和主机名"
    sed -i "s/IPADDR=.*/IPADDR=$IP/g" /template/conf/ifcfg-eth0
    sed -i "s/HOSTNAME=.*/HOSTNAME=centos7.0-VM$y/g" /template/conf/network
    
###############must : yum install libguestfs-tools ################
    virt-copy-in -d centos7.0-VM$y /template/conf/network /etc/sysconfig/
    virt-copy-in -d centos7.0-VM$y /template/conf/ifcfg-eth0 /etc/sysconfig/network-scripts/
######################################################################
}
#main shell script
echo -n "请输入虚拟机名称: "
read y
echo "检查可用IP地址（100-150）"
trap '{ echo "Hey, you pressed Ctrl-C.  Time to quit." ; exit 1; }' INT
echo -e "可以键入 Ctrl-C/退出IP检查但继续执行$(basename $0).\n"
echo -e "可用IP地址如下：\n"
Check_Ip
echo -e "请输入虚拟机选择的IP地址："
read IP
echo -e "正在创建虚拟主机，请稍后...\n"
Create_Host
echo -n ""
Change_Ip
echo -e "启动虚拟机..."
Doing
virsh start centos7.0-VM$y >>/tmp/vminstall.log 2>&1 
echo -e "生成虚拟机信息如下：\n"
virsh list |grep centos7.0-VM$y
echo "centos7.0-VM$y IP:$IP Password:123456"



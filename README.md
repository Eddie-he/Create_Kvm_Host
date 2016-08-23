# Create_Kvm_Host
在Linux KVM环境下利用模板快速生成虚拟主机。
1.脚本主要是在Linux KVM环境下通过模板快速生成虚拟机，并配置静态IP地址。
![image](https://github.com/Eddie-he/Create_Kvm_Host/blob/master/images/%E7%94%9F%E6%88%90%E8%99%9A%E6%8B%9F%E6%9C%BA.png)
2.主机模板配置和服务信息如下：
  2 Vcpu 2G Memory 50G Disk
  虚拟机模板服务包含：MariaDB、Redis、MongoDB 
3.脚本以及模板文件目录结构如下：
![image](https://github.com/Eddie-he/Create_Kvm_Host/blob/master/images/%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84.png)

备注：脚本具体使用和实际环境需要自己修改
demo环境网络为192.168.1.0/24需要安装 yum install libguestfs-tools 工具在宿主机才能修改模板镜像IP和主机名

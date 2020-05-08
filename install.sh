#!/bin/bash
basepath=$(cd `dirname $0`; pwd)
cd `dirname $0`
tar xzvf  ./figlet.tar   -C  /  >/dev/null
basepath=$(cd `dirname $0`; pwd)
# figlet
figlet  Kubernets  -f  ./larry3d.flf
start=`date +%s`  >/dev/null
echo $basepath
ln  -sf  ${basepath}  /root/K8s
#合并kubernetes-server-linux-amd64.tar.gz分卷,(解决git不能上传大于100M的问题)git下来后只会在第一次执行
# ls -l   /root/K8s/Software_package/kubernetes-server-linux-amd64.tar.a*  2> /dev/null && {
# cat   /root/K8s/Software_package/kubernetes-server-linux-amd64.tar.a*  > /root/K8s/Software_package/kubernetes-server-linux-amd64.tar.gz 
# rm -f /root/K8s/Software_package/kubernetes-server-linux-amd64.tar.a*
# tar xzvf  /root/K8s/Software_package/kubernetes-server-linux-amd64.tar.gz  -C /root/K8s/Software_package/
# }

cd  /root/K8s/Software_package/
rpm -ivh /root/K8s/yum/bc-1.06.95-13.el7.x86_64.rpm  2>/dev/null >/dev/null
rpm  -ivh  /root/K8s/yum/unzip-6.0-19.el7.x86_64.rpm  
. /root/K8s/single_shell/var_.sh

sleep 5
figlet  Kubernets 
##########
#选择集群安装或者单机安装
_menu_A 

#恢复第三方源
#替换第三方yum源
ansible all -m shell -a   "rm  -fv  rm -f /etc/yum.repos.d/* "
ansible all -m shell -a   "while  [ true ]; do  curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo   && break  1   ;done"
ansible all -m shell -a   "while  [ true ]; do  curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo   && break  1   ;done"
#修复授权
ansible all -m shell -a   "chmod  +x  /etc/rc.local"
ansible all -m shell -a   "systemctl disable   docker  kubelet  kube-proxy  2>/dev/null||true"
ansible all -m shell -a   "systemctl disable  kube-apiserver    kube-scheduler    kube-controller-manager   docker  kubelet  kube-proxy  2>/dev/null||true"
ansible all -m shell -a   "grep  "k8s-start"  /etc/rc.local|| curl -s  ${IP}:42344/boot.sh >>/etc/rc.local"
ansible all -m shell -a   " grep   '\#\!\/bin\/bash'  /etc/rc.d/rc.local|| sed  -i '1 i\#\!\/bin\/bash'   /etc/rc.d/rc.local"
ansible all -m shell -a   " grep   'touch \/var\/lock\/subsys\/local'  /etc/rc.d/rc.local|| sed  -i  '/\#\!\/bin\/bash/a\touch \/var\/lock\/subsys\/local'    /etc/rc.d/rc.local "

#


end=`date +%s`  >/dev/null
dif=$[ end - start ]
DIF=$(echo "scale=0;${dif} / 60"|bc)
[ $DIF -lt 1  ]|| {
figlet  kubernetes  -f  /root/K8s/larry3d.flf
echo " "
echo " "    
echo  -e "此次脚本执行耗时:  \n $(figlet       $DIF Min)"
}


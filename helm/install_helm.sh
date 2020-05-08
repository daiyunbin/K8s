#!/bin/bash
#离线安装Helm，master节点执行
#安装helm
yum install -y socat  
IP=$(hostname -I |xargs -n 1   | grep  $(ip route |head  -n 1 | awk    '{print  $3}'  |  awk  -F  '.'  '{print  $1"."$2"."$3}')) ||IP=$(hostname -I |xargs -n 1   | grep  $(ip route |head  -n 1 | awk    '{print  $3}'  |  awk  -F  '.'  '{print  $1"."$2"."}'))
tar  -xzvf  /root/K8s/Software_package/helm-v*-linux-amd64.tar.gz   -C    /usr/local/bin/
\cp  -av /usr/local/bin/linux-amd64/helm    /usr/local/bin
rm  -rvf  /usr/local/bin/linux-amd64/
#ansible  all  -m shell -a  "yum install -y socat"
#创建tiller的serviceaccount和clusterrolebinding
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# kubectl create serviceaccount --namespace kub
#安装helm服务端tiller
helm init --upgrade -i registry.cn-chengdu.aliyuncs.com/set/k8s/tiller:v2.15.2   --stable-repo-url    http://$IP:42344/
#为应用程序设置serviceAccount：
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
#检查是否安装成功：
kubectl -n kube-system get pods|grep tiller
while  [ true ]; do  kubectl -n kube-system get pods|grep tiller;sleep 1;kubectl -n kube-system get pods|grep tiller|grep  Running |grep  '1\/1'  && break  1   ;done
echo ok
sleep 2
helm  version&& echo  "helm安装成功！！"






# ################################################################
# cat  > rbac-config.yaml  <<EOF
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   name: tiller
#   namespace: kube-system
# ---
# apiVersion: rbac.authorization.k8s.io/v1beta1
# kind: ClusterRoleBinding
# metadata:
#   name: tiller
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: cluster-admin
# subjects:
#   - kind: ServiceAccount
#     name: tiller
#     namespace: kube-system
# EOF
# kubectl create -f rbac-config.yaml 
# 部署流程

行结束问题

## requirement

- k8s、containerd
- 安装英伟达显卡驱动和cuda（下载CUDA Toolkit即可）

​		ref：https://developer.nvidia.com/cuda-toolkit-archive

## 1、

``````
kubectl create sa gpu-manager -n kube-system
kubectl create clusterrolebinding gpu-manager-role --clusterrole=cluster-admin --serviceaccount=kube-system:gpu-manager

kubectl label node <你的GPU节点> nvidia-device-enable=enable
``````

## 2、修改kube-scheduler.yaml文件

- 备份kube-scheduler.yaml文件

``````
cp /etc/kubernetes/kube-scheduler.yaml ./
``````

- command处增加

``````
- command:
  - --config=/etc/kubernetes/scheduler-extender.yaml
``````

- volumeMounts处增加

``````
volumeMounts:
- mountPath: /etc/localtime
      name: localtime
      readOnly: true
- mountPath: /etc/kubernetes/scheduler-extender.yaml
      name: extender
      readOnly: true
- mountPath: /etc/kubernetes/scheduler-policy-config.json
      name: extender-policy
      readOnly: true
``````

- volumes处增加

``````
volumes:
- hostPath:
      path: /etc/localtime
      type: File
    name: localtime
- hostPath:
      path: /etc/kubernetes/scheduler-extender.yaml
      type: FileOrCreate
    name: extender
- hostPath:
      path: /etc/kubernetes/scheduler-policy-config.json
      type: FileOrCreate
    name: extender-policy
``````

## 3、

``````
chmod +x gpuDeploy.sh
./gpuDeploy.sh
``````




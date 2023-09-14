admissionDir="/etc/kubernetes"
schedulerYamlDir="$admissionDir/manifests"

cp scheduler-extender.yaml "$admissionDir"
cp scheduler-policy-config.json "$admissionDir"
cp kube-scheduler.yaml "$schedulerYamlDir"

kubectl apply -f gpu-admission.yaml
sleep 3
kubectl apply -f gpu-manager.yaml



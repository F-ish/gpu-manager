admissionDir="/etc/kubernetes"
schedulerYamlDir="$admissionDir/manifests"

wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda_11.7.1_515.65.01_linux.run 
sudo sh cuda_11.7.1_515.65.01_linux.run --silent --driver --toolkit --samples --override

git clone https://github.com/F-ish/vcuda-controller.git
cd vcuda-controller
./build-img.sh
cd ../
docker save fish/vcuda:latest -o fish-vcuda.tar
ctr -n=k8s.io image import fish-vcuda.tar

git clone https://github.com/F-ish/gpu-manager.git
cd gpu-manager
make img
cd ../
docker save fish/gpu-manager:1.0.0 -o fish-manager.tar
ctr -n=k8s.io image import fish-manager.tar
cd gpu-manager/relateYamlFile

cp "$schedulerYamlDir/kube-scheduler.yaml" kube-scheduler.yaml.bak
cp scheduler-extender.yaml "$admissionDir"
cp scheduler-policy-config.json "$admissionDir"
cp kube-scheduler.yaml "$schedulerYamlDir"

kubectl apply -f gpu-admission.yaml
sleep 3
kubectl apply -f gpu-manager.yaml



@ echo off
:: 1. Start minikube (Docker is default - I use VMware, virtualbox is default)
echo "Starting minikube..."
echo
minikube start --driver=vmware
:: 2. Start NFS Server in kube-system
echo "Starting Local NFS server..."
echo " "
kubectl apply -f nfs-server-k8s.yaml
:: 3. Add helm chart (if not already added)
echo "Adding Helm chart (disregard if already added)"
echo " "
helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
:: 4. Install csi driver for NFS storage
echo "Install Helm chart for csi-driver-nfs..."
echo " "
helm repo update
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system
:: helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --version v3.1.0
:: 5. Add StorageClass to dynamically create Persistent Volumes
echo "Adding StorageClass for persistent volume..."
echo " "
kubectl apply -f storageClass.yaml
:: 6. Start Busybox
echo "Starting test pod with PVC to mount volume..."
echo " "
kubectl apply -f busybox-nfs-pvc-csi.yaml

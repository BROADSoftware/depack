
kubectl create namespace gha1 && helm upgrade -i -n gha1 --values ./values.kspray1.local.yaml gha2s3 .

helm -n gha1 uninstall gha2s3 && kubectl delete namespace gha1 

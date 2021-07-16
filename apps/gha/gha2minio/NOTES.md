
kubectl create namespace gha1
helm upgrade -i -n gha1 --values ./values.kspray1.local.yaml gha2minio .


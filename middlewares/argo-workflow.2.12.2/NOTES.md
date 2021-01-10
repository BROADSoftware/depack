
# Patching from provided install manifest

Move crds in specific folder

Patch the configMap as follow:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: workflow-controller-configmap
data:
  containerRuntimeExecutor: k8sapi
```

And patch 
```
namespace: {{ .Release.Namespace }}
```
In two roleBinding


# Port forwarding
kubectl -n argo port-forward service/argo-server 2746


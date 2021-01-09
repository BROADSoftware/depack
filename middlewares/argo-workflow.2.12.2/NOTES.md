
Patch the configMap as follow:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: workflow-controller-configmap
data:
  containerRuntimeExecutor: k8sapi
```


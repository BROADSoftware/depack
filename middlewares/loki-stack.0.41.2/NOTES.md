
# Wrapper or expanded chart ? 

This was preferred to a wrapper around helm chart like this:

```
apiVersion: v2
name: loki-stack-wrapper
version: 0.1.0
dependencies:
- name: loki-stack
  repository: https://grafana.github.io/loki/charts
  version: "0.41.2"
```  

less flexible

# Reset admin password.

Log on the grafana pod and:

```shell script
admin  reset-admin-password admin
```
Ref: https://stackoverflow.com/questions/59838690/how-to-reset-grafanas-admin-password-installed-by-helm
 
# Test

```shell script
helm upgrade --install --dry-run --debug --values ./values-xx.yaml --namespace loki loki . >xx.yaml
helm upgrade --install --values ./values-xx.yaml --namespace loki loki .
```
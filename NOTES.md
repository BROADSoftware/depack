
Get initial password and change it

```
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
argocd login argocd.ingress.ksprayX.ctb01
argocd account update-password
```

Add git repos

```
argocd repo add https://github.com/SergeAlexandre/ctrlk.git --username "sa@broadsoftware.com" --password xxxx

argocd repo add https://github.com/BROADSoftware/depack.git --username "sa@broadsoftware.com" --password xxxx
```


# Register cluster

Ensure $KUBECONFIG target cluster to register

```
argocd cluster add
argocd cluster add <contextName>
```



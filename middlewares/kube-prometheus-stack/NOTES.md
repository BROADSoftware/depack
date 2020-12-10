# Modification from original chart

- deploy grafana, kube-static-metric and prometheus-node-exporter in charts folder.
- Set apiVersion in Chart.yaml to v2 (*)
- In values.yaml:
  - `rbac.pspUseAppArmor: false` as we are on centos
  - `serviceMonitorSelectorNilUsesHelmValues`, `podMonitorSelectorNilUsesHelmValues`, `probeSelectorNilUsesHelmValues` to false, to allow easy post-install of monitors. 

(*)
- v1 will not take `crds` folder in account.
- spec.source.helm.version: v2/3 in application yaml is not handled by argocd (seems a bug)



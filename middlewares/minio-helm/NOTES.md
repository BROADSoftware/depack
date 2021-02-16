
Edited chart apiVersion from v1 to v2


## Application example : 
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: minio3-kspray2-ctb02
      namespace: argocd
    spec:
      source:
        repoURL: https://github.com/BROADSoftware/depack.git
        path: middlewares/minio-helm
        helm:
          valueFiles:
            - targets/base_cacib.yaml
          values: |
            clusterDomain: kspray2
    
            accessKey: "admin"
            secretKey: "admin123"
    
            drivesPerNode: 4
            replicas: 4
    
            tls:
              certSecret: "minio3-tls"
    
            persistence:
              storageClass: "topolvm-ssd1"
              size: 2Gi
    
            ingress:
              hosts:
                - minio3.ingress.kspray2.ctb02
              tls:
                - secretName: minio3-tls
                  hosts:
                    - minio3.ingress.kspray2.ctb02
                    - '*.minio3-kspray2-ctb02-svc.minio3.svc.kspray2'
    
      destination:
        namespace: minio3
        server: https://kubernetes.default.svc
      project: default
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
    
    
    






# Modification on opendistro helm chart (v1.10.1)

Aim of these modification is to:

- Provide a non-demo certificate for transport, signed by cert-manager
- Provide a certificate signed also by cert-manager for rest access.
- Reduce the number of parameter to define for each instance to be created.

In short, these modification are:

- Add a default elastic.yaml configuration in Values file
- Change some certificate path in Values.yaml to adjust to the layout of cert-manager secret generation
- Add some code in template to generate some boilerplate definition.

## Values file

- Add a new variable `elasticsearch.ingressHost: ""` placeholder for documentation purpose.
- Modify elasticsearch.ssl.transport and elasticsearch.ssl.rest as below
- fulfill elasticsearch.config with config default value.
- Add a elastic.configOverride: {} placholder for documentation purposes

```
elasticsearch:
  # Setting this value will:
  # - Trigger generation a a certficate
  # -   Will trigger generation of nginx ingress controller in ssl passthrough mode on cluent
  ingressHost: ""
  ....
  ....
  ssl:
    ## TLS is mandatory for the transport layer and can not be disabled
    transport:
      existingCertSecret: elastic-transport-tls
      existingCertSecretCertSubPath: tls.crt
      existingCertSecretKeySubPath: tls.key
      existingCertSecretRootCASubPath: ca.crt
    rest:
      enabled: true
      existingCertSecret: elastic-rest-tls
      existingCertSecretCertSubPath: tls.crt
      existingCertSecretKeySubPath: tls.key
      existingCertSecretRootCASubPath: ca.crt  
      
      
      
  config:
    cluster.name: "docker-cluster"
    network.host: 0.0.0.0  
    opendistro_security.ssl.transport.pemcert_filepath: elk-transport-crt.pem
    opendistro_security.ssl.transport.pemkey_filepath: elk-transport-key.pem
    opendistro_security.ssl.transport.pemtrustedcas_filepath: elk-transport-root-ca.pem
    opendistro_security.ssl.transport.enforce_hostname_verification: false
    opendistro_security.nodes_dn:
    - 'CN=to.replace.by.ingressHost'
    opendistro_security.ssl.http.enabled: true
    opendistro_security.ssl.http.pemcert_filepath: elk-rest-crt.pem
    opendistro_security.ssl.http.pemkey_filepath: elk-rest-key.pem
    opendistro_security.ssl.http.pemtrustedcas_filepath: elk-rest-root-ca.pem

    opendistro_security.allow_default_init_securityindex: true
    opendistro_security.authcz.admin_dn:
      - CN=admin
    
    opendistro_security.audit.type: internal_elasticsearch
    opendistro_security.enable_snapshot_restore_privilege: true
    opendistro_security.check_snapshot_restore_write_privileges: true
    opendistro_security.restapi.roles_enabled: ["all_access", "security_rest_api_access"]
    cluster.routing.allocation.disk.threshold_enabled: false
    node.max_local_storage_nodes: 3

  # To be override by caller if needed
  configOverride: {}      
```      

## elasticsearch-certificate.yaml

This is a new file, hosting certificate for transport and rest interface

```
# This certificate is used for both transport and http connection
{{ if .Values.elasticsearch.ingressHost }}
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: elastic-rest-tls
  namespace: {{ .Release.Namespace }}
spec:
  commonName: {{ .Values.elasticsearch.ingressHost }}
  secretName: elastic-rest-tls
  keyEncoding: pkcs8  
  dnsNames:
    - {{ .Values.elasticsearch.ingressHost }}
  issuerRef:
    name: {{ .Values.clusterIssuer }}
    kind: ClusterIssuer
{{ end }}

---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: elastic-transport-tls
  namespace: {{ .Release.Namespace }}
spec:
  commonName: {{ .Release.Namespace }}-{{.Release.Name}}
  secretName: elastic-transport-tls
  keyEncoding: pkcs8
  dnsNames:
    - {{ .Release.Namespace }}-{{.Release.Name}}
  issuerRef:
    name: {{ .Values.clusterIssuer }}
    kind: ClusterIssuer
```

## es-client-ingress.yaml

The following snippet is added at the top of the file. It will configure all ingress related values to set an nginx ingress in ssl passthrough mode. 

```
{{ if .Values.elasticsearch.ingressHost }}
{{ $_ := set .Values.elasticsearch.client.ingress "enabled" true }}
{{ $myannotations := dict "kubernetes.io/ingress.class" "nginx" "nginx.ingress.kubernetes.io/force-ssl-redirect" "true" "nginx.ingress.kubernetes.io/ssl-passthrough" "true" }}
{{ $_ := set .Values.elasticsearch.client.ingress "annotations" $myannotations}}
{{ $_ := set .Values.elasticsearch.client.ingress "hosts" (list .Values.elasticsearch.ingressHost ) }}
{{ end }}
```

## es-config-secret.yaml

The following snippet is added at the top of the file. It will build the elasticsearch.yml configuration file in a '$myconfig' variable.

```
{{ $myconfig := .Values.elasticsearch.config }}
{{ $myconfig = merge (dict "opendistro_security.nodes_dn" (list (printf "CN=%s-%s"  .Release.Namespace .Release.Name ))) $myconfig }}
{{ $myconfig = merge (dict "cluster.name" (printf "%s-%s"  .Release.Namespace .Release.Name )) $myconfig }}
{{ if .Values.elasticsearch.configOverride }}
{{ $myconfig = merge .Values.elasticsearch.configOverride $myconfig }}
{{ end }}
```

And then this variable will be injected in the config secret:

```
data:
  {{- if $myconfig }}
  elasticsearch.yml: {{ toYaml $myconfig | b64enc | quote }}
  {{- end }}
```

## kibana-ingress.yaml

The following snippet is added at the top of the file. It will configure all ingress related values to set an nginx ingress with a certificate generated by cert-manager?

```
{{ if .Values.kibana.ingressHost }}
{{ $_ := set .Values.kibana.ingress "enabled" true }}
{{ $myannotations := dict "kubernetes.io/ingress.class" "nginx" "nginx.ingress.kubernetes.io/force-ssl-redirect" "true" "cert-manager.io/cluster-issuer" .Values.clusterIssuer }}
{{ $_ := set .Values.kibana.ingress "annotations" $myannotations}}
{{ $_ := set .Values.kibana.ingress "hosts" (list .Values.kibana.ingressHost ) }}
{{ $_ := set .Values.kibana.ingress "tls" (list (dict "secretName" "kibana-tls" "hosts" (list .Values.kibana.ingressHost))) }}
{{ end }}
```


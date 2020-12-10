{{- define "kafkaCluster.clusterName" -}}
{{- default .Release.Name .Values.clusterName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

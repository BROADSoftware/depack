{{- define "minio.tenantName" -}}
{{- default .Release.Name .Values.tenantName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

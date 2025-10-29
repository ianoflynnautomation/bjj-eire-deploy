{{/*
Expand the name of the chart.
*/}}
{{- define "bjj-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bjj-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bjj-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bjj-api.labels" -}}
helm.sh/chart: {{ include "bjj-api.chart" . }}
{{ include "bjj-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: api
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bjj-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bjj-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: api
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bjj-api.serviceAccountName" -}}
{{- if .Values.api.serviceAccount.create }}
{{- default (include "bjj-api.fullname" .) .Values.api.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.api.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate MongoDB connection string
*/}}
{{- define "bjj-api.mongodb.connectionString" -}}
{{- $mongodbRootPassword := "" -}}
{{- if .Values.azure.enabled -}}
  {{- $secret := lookup "v1" "Secret" .Values.namespace .Values.secrets.mongodbRootPassword.name -}}
  {{- if $secret -}}
    {{- $mongodbRootPassword = index $secret.data .Values.secrets.mongodbRootPassword.key | b64dec -}}
  {{- else -}}
    {{- fail (printf "Secret '%s' not found for Azure deployment. Ensure Secret Store CSI driver is syncing it from Key Vault." .Values.secrets.mongodbRootPassword.name) -}}
  {{- end -}}
{{- else -}}
  {{- if .Values.secrets.mongodbRootPassword.value -}}
    {{- $mongodbRootPassword = .Values.secrets.mongodbRootPassword.value | b64dec -}}
  {{- else -}}
    {{- $secret := lookup "v1" "Secret" .Values.namespace .Values.secrets.mongodbRootPassword.name -}}
    {{- if $secret -}}
      {{- $mongodbRootPassword = index $secret.data .Values.secrets.mongodbRootPassword.key | b64dec -}}
    {{- else -}}
      {{- fail (printf "MongoDB password not found. Secret '%s' does not exist in namespace '%s'. Please ensure MongoDB is deployed first or provide secrets.mongodbRootPassword.value" .Values.secrets.mongodbRootPassword.name .Values.namespace) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- printf "mongodb://%s:%s@%s:%s/%s?authSource=admin&authMechanism=SCRAM-SHA-256" .Values.mongodb.config.user $mongodbRootPassword .Values.mongodb.config.host (.Values.mongodb.config.port | toString) .Values.mongodb.config.database -}}
{{- end }}
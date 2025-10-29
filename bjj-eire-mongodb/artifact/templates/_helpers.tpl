{{/*
Expand the name of the chart.
*/}}
{{- define "bjj-mongodb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bjj-mongodb.fullname" -}}
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
{{- define "bjj-mongodb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bjj-mongodb.labels" -}}
helm.sh/chart: {{ include "bjj-mongodb.chart" . }}
{{ include "bjj-mongodb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bjj-mongodb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bjj-mongodb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bjj-mongodb.serviceAccountName" -}}
{{- if .Values.mongodb.serviceAccount.create }}
{{- default (include "bjj-mongodb.fullname" .) .Values.mongodb.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.mongodb.serviceAccount.name }}
{{- end }}
{{- end }}
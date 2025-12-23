{{/*
Expand the name of the chart.
*/}}
{{- define "task-manager.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "task-manager.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.global.nameOverride }}
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
{{- define "task-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "task-manager.labels" -}}
helm.sh/chart: {{ include "task-manager.chart" . }}
{{ include "task-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "task-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "task-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
PostgreSQL fullname
*/}}
{{- define "task-manager.postgresql.fullname" -}}
{{- printf "%s-postgresql" (include "task-manager.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Dragonfly fullname
*/}}
{{- define "task-manager.dragonfly.fullname" -}}
{{- printf "%s-dragonfly" (include "task-manager.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Database connection string
*/}}
{{- define "task-manager.database.connectionString" -}}
{{- printf "jdbc:postgresql://%s:5432/%s" (include "task-manager.postgresql.fullname" .) .Values.postgresql.auth.database }}
{{- end }}

{{/*
Redis connection string
*/}}
{{- define "task-manager.redis.host" -}}
{{- printf "%s" (include "task-manager.dragonfly.fullname" .) }}
{{- end }}
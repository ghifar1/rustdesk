{{/*
Expand the name of the chart.
*/}}
{{- define "rustdesk.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rustdesk.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart label.
*/}}
{{- define "rustdesk.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{/*
Common metadata labels.
*/}}
{{- define "rustdesk.labels" -}}
helm.sh/chart: {{ include "rustdesk.chart" . }}
{{ include "rustdesk.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Chart.AppVersion }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "rustdesk.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rustdesk.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Service account name.
*/}}
{{- define "rustdesk.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "rustdesk.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Primary hbbs Service name.
*/}}
{{- define "rustdesk.hbbsServiceName" -}}
{{ include "rustdesk.fullname" . }}
{{- end -}}

{{/*
hbbr Service name (relay).
*/}}
{{- define "rustdesk.hbbrServiceName" -}}
{{- printf "%s-relay" (include "rustdesk.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Relay address used for hbbs RELAY env.
*/}}
{{- define "rustdesk.relayAddress" -}}
{{- if .Values.server.relayAddress }}
{{- tpl .Values.server.relayAddress . -}}
{{- else -}}
{{- $host := tpl (default "" .Values.server.relayHost) . -}}
{{- if not $host }}
{{- $host = printf "%s.%s.svc" (include "rustdesk.hbbrServiceName" .) .Release.Namespace -}}
{{- end -}}
{{- $port := default 21117 .Values.server.relayPort -}}
{{- printf "%s:%v" $host $port -}}
{{- end -}}
{{- end -}}

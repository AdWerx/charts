{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "awx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "awx.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "awx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common volume mounts
*/}}
{{- define "awx.volumeMounts" -}}
- name: settings
  mountPath: "/etc/tower/settings.py"
  subPath: settings.py
  readOnly: true
- name: confd
  mountPath: "/etc/tower/conf.d/"
  readOnly: true
- name: secret-key
  mountPath: "/etc/tower/SECRET_KEY"
  subPath: SECRET_KEY
  readOnly: true
{{- end -}}

{{/*
Common volume definitions
*/}}
{{- define "awx.volumes" -}}
- name: settings
  configMap:
    name: {{ include "awx.fullname" . }}-settings
    items:
      - key: settings.py
        path: settings.py
- name: secret-key
  secret:
    secretName: {{ include "awx.fullname" . }}-secret-key
    items:
      - key: SECRET_KEY
        path: SECRET_KEY
- name: confd
  secret:
    secretName: {{ include "awx.fullname" . }}-confd
{{- end -}}

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
- name: redis-socket
  mountPath: /var/run/redis
{{- end -}}

{{/*
ServiceAccount name for app pods
*/}}
{{- define "awx.serviceAccountName" -}}
{{- default "awx" .Values.serviceAccountName -}}
{{- end -}}

{{/*
provides the correct name of the secret where
the default admin user credentials can be found
*/}}
{{- define "awx.defaultAdminSecretName" -}}
{{- default (include "awx.fullname" .) .Values.defaultAdminExistingSecret -}}
{{- end -}}

{{/*
provides the correct name of the secret where
the postgresql connection details can be found
*/}}
{{- define "awx.postgresqlSecretName" -}}
{{- default (include "awx.fullname" .) .Values.postgresqlExistingSecret -}}
{{- end -}}

{{/*
provides the correct name of the secret where
the AWX SECRET_KEY can be found
*/}}
{{- define "awx.secretKeySecretName" -}}
{{- default (include "awx.fullname" .) .Values.secretKeyExistingSecret -}}
{{- end -}}

{{/*
provides the container env definitions
*/}}
{{- define "awx.env" -}}
- name: MY_POD_IP
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: MY_POD_UID
  valueFrom:
    fieldRef:
      fieldPath: metadata.uid
- name: AWX_ADMIN_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.defaultAdminSecretName" . }}
      key: AWX_ADMIN_USER
- name: AWX_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.defaultAdminSecretName" . }}
      key: AWX_ADMIN_PASSWORD
- name: DATABASE_NAME
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.postgresqlSecretName" . }}
      key: DATABASE_NAME
- name: DATABASE_HOST
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.postgresqlSecretName" . }}
      key: DATABASE_HOST
- name: DATABASE_PORT
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.postgresqlSecretName" . }}
      key: DATABASE_PORT
- name: DATABASE_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.postgresqlSecretName" . }}
      key: DATABASE_USER
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.postgresqlSecretName" . }}
      key: DATABASE_PASSWORD
- name: DATABASE_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.postgresqlSecretName" . }}
      key: DATABASE_ADMIN_PASSWORD
- name: SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "awx.secretKeySecretName" . }}
      key: SECRET_KEY
{{- end -}}

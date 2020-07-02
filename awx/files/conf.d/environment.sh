DATABASE_USER={{ .Values.postgresql.postgresqlUsername }}
DATABASE_NAME={{ .Values.postgresql.postgresqlDatabase }}
{{- if .Values.postgresql.postgresqlHost }}
DATABASE_HOST={{ .Values.postgresql.postgresqlHost }}
{{ else }}
DATABASE_HOST={{ .Release.Name }}-postgresql
{{ end -}}
DATABASE_PORT={{ .Values.postgresql.service.port }}
DATABASE_PASSWORD={{ .Values.postgresql.postgresqlPassword }}
DATABASE_ADMIN_PASSWORD={{ .Values.postgresql.postgresqlPassword }}
MEMCACHED_HOST={{ .Release.Name }}-memcached
MEMCACHED_PORT=11211
RABBITMQ_HOST={{ .Release.Name }}-rabbitmq
RABBITMQ_PORT={{ .Values.rabbitmq.service.port }}
AWX_ADMIN_USER={{ .Values.default_admin_user }}
AWX_ADMIN_PASSWORD={{ .Values.default_admin_password }}

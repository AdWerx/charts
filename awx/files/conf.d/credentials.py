DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'awx.main.db.profiled_pg',
        'NAME': "{{ .Values.postgresql.postgresqlDatabase }}",
        'USER': "{{ .Values.postgresql.postgresqlUsername }}",
        'PASSWORD': "{{ .Values.postgresql.postgresqlPassword }}",
        {{- if .Values.postgresql.postgresqlHost }}
        'HOST': "{{ .Values.postgresql.postgresqlHost }}",
        {{ else }}
        'HOST': "{{ .Release.Name }}-postgresql",
        {{ end -}}
        'PORT': "{{ .Values.postgresql.service.port }}",
    }
}

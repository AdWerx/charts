DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'awx.main.db.profiled_pg',
        'NAME': "{{ .Values.postgresql.postgresqlDatabase }}",
        'USER': "{{ .Values.postgresql.postgresqlUsername }}",
        'PASSWORD': "{{ .Values.postgresql.postgresqlPassword }}",
        'HOST': "{{ .Release.Name }}-postgresql",
        'PORT': "{{ .Values.postgresql.service.port }}",
    }
}
BROKER_URL = 'amqp://{}:{}@{}:{}/{}'.format(
    "{{ .Values.rabbitmq.rabbitmq.username }}",
    "{{ .Values.rabbitmq.rabbitmq.password }}",
    "{{ .Release.Name }}-rabbitmq",
    "{{ .Values.rabbitmq.service.port }}",
    "awx")
CHANNEL_LAYERS = {
    'default': {'BACKEND': 'asgi_amqp.AMQPChannelLayer',
                'ROUTING': 'awx.main.routing.channel_routing',
                'CONFIG': {'url': BROKER_URL}}
}

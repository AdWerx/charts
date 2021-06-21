2021-06-16 - 3.0.0
---

RabbitMQ and memcached were removed as depdencies of AWX and redis was introduced in their place. Configuration settings have been updated and external redis is configurable via `.Values.redis.host` and `.Values.redis.port`.

`.Values.web.(image|affinity|nodeSelector|tolerations|replicaCount)` and `.Values.task.(image|affinity|nodeSelector|tolerations|replicaCount)` have been consolidated to `.Values.image` since there is only one AWX image as of verison 12. Please update your values files accordingly if you reference these.

No extra upgrade steps are necessary at this time.

- Service Account added for AWX pod by default
- Upgraded to AWX 16
- Removed RabbitMQ
- Removed Memcached
- Added redis as a subchart
- Combined awx_web and awx_task since they depend on websocket connections via cluster membership (localhost works, hostnames do not work so well)

2020-06-20 - 2.2.2
---

- Fixed external postgres host variable DATABASE_HOST #14

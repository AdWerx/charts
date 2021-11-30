2021-11-30 - 3.4.0
---

* Support stable networking API for ingress and APIs for older kube versions

2021-06-25 - 3.2.1
---

* Fix issue with using `postgresqlExistingSecret` in which credentials were not used in `credentials.py` #24

2021-06-25 - 3.2.0
---

* Resolves issue with instance registration in which instances did not record their IP or Pod UID. This broke websocket broadcasting to instance peers.
* Redis was moved to a container within the pod since it is assumed to be shared between web and task processes. It does not need to be shared amongst all task processes as it is not the centralized message broker.
* Readiness probe was added to the web container

2021-06-21 - 3.1.0
---

* Allow existing secrets to be used for default admin login, postgres connection details, and the AWX secret key. #22

2021-06-21 - 3.0.1
---

* Include AWX_ANSIBLE_COLLECTIONS_PATHS variable in settings so dynamic inventory plugins work correctly

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

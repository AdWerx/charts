<!--
STOP! README.md is automatically generated using helm-docs
Run `helm-docs .` to generate.
If you're looking at README.md.gotmpl, then you're in the right place.
-->
# Ansible AWX



![Version: 3.0.1](https://img.shields.io/badge/Version-3.0.1-informational?style=flat-square) ![AppVersion: 16.0.0](https://img.shields.io/badge/AppVersion-16.0.0-informational?style=flat-square) 

AWX provides a web-based user interface, REST API, and task engine built on top of Ansible. It is the upstream project for Tower, a commercial derivative of AWX.

**Homepage:** <https://github.com/ansible/awx>

## Installation

Add our repo:

```bash
helm repo add adwerx https://adwerx.github.io/charts
```

Install the chart:

```bash
helm install adwerx/awx
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Josh Bielick |  | https://github.com/jbielick |

## Source Code

* <https://github.com/AdWerx/charts/tree/master/awx>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
|  | postgresql | 6.3.2 |
| https://charts.bitnami.com/bitnami | redis | 14.4.0 |

## Job Isolation and Security Context

Ansible AWX task runners employ a legacy process isolation for playbook runs (jobs) via [bubblewrap](https://github.com/containers/bubblewrap). The purpose of this isolation is [to restrict access to shared AWX subsystems, which could be multi-tenant](https://github.com/ansible/awx/pull/7188#issuecomment-636069719)—access the AWX task pod has and could be exploited. If you are not using AWX in a multi-tenant fashion and trust users writing playbooks to have full access to a Pod in your cluster, you may choose to disable bubblewrap. If you'd like to retain bubblewrap isolation on playbook runs in a kubernetes deployment, you'll need to run the AWX task pods with a privileged security context (PR welcome).

Per the AWX documentation, if you choose to turn off Job Isolation you can do so by following the instructions below:

> **Disabling bubblewrap support:**
> To disable bubblewrap support for running jobs (playbook runs only), ensure you are  logged in as the Admin user and click on the settings gear settings in the upper right-hand corner. Click on the “Configure Tower” box, then click on the “Jobs” tab. Scroll down until you see “Enable Job Isolation” and change the radio button selection to “off”.

[More information on the future of playbook isolation here](https://github.com/ansible/awx/issues/7060)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | string | `nil` |  |
| defaultAdminExistingSecret | string | `nil` | The name of an existing secret in the same namespace containing `AWX_ADMIN_USER` and `AWX_ADMIN_PASSWORD` keys and values |
| defaultAdminPassword | string | `nil` | The seeded admin user credentials. You must set this value or provide defaultAdminExistingSecret |
| defaultAdminUser | string | `nil` | The seeded admin user credentials. You must set this value or provide defaultAdminExistingSecret |
| default_admin_password | string | `nil` |  |
| default_admin_user | string | `nil` |  |
| extraConfiguration | string | `"# INSIGHTS_URL_BASE = \"https://example.org\""` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ansible/awx"` |  |
| image.tag | string | `"16.0.0"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.defaultBackend | bool | `true` | Whether the default backend for this ingress should route to the awx service |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` | Define ingress routing here |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | string | `nil` |  |
| postgresql | object | `{"enabled":true,"image":{"registry":"docker.io","repository":"bitnami/postgresql","tag":9.6},"metrics":{"enabled":false},"persistence":{"enabled":true},"postgresqlDatabase":"awx","postgresqlHost":null,"postgresqlPassword":null,"postgresqlUsername":"awx","service":{"port":"5432"}}` | See bitnami/postgresql chart values for all options |
| postgresql.enabled | bool | `true` | Set to false if using external postgresql |
| postgresql.postgresqlHost | string | `nil` | Set this only if using an external postgresql database. Alternatively, you can provide this value through postgresqlExistingSecret. |
| postgresql.postgresqlPassword | string | `nil` | You must set this value or provide postgresqlExistingSecret |
| postgresql.pv.enabled | bool | `false` | Set to true if you want to create local pv |
| postgresql.pv.size | string | `8Gi` | Size of the local pv to create postgres default is 8Gi |
| postgresql.pv.path | string | `"/mnt/data"` | path of where to mount the pv |
| postgresql.volumePermissions.enabled | bool | `false` | Set to true if you want to create local pv with non root permissions |
| postgresqlExistingSecret | string | `nil` | The name of an existing secret in the same namespace containing DATABASE_USER, DATABASE_NAME, DATABASE_HOST, DATABASE_HOST, DATABASE_PORT, DATABASE_PASSWORD, DATABASE_ADMIN_PASSWORD keys and values |
| redis | object | `{"architecture":"standalone","auth":{"enabled":false},"enabled":true,"host":null,"image":{"tag":"6.2.4"},"port":6379}` | See bitnami/redis chart values for all options |
| redis.enabled | bool | `true` | Set to false if using external redis |
| redis.host | string | `nil` | Enter host if using external redis |
| redis.image.pullPolicy | string | `"IfNotPresent"` |  |
| redis.image.repository | string | `"redis"` |  |
| redis.image.tag | string | `"6.2.4"` |  |
| replicaCount | int | `1` |  |
| secretKey | string | `nil` | The key used to encrypt secrets in the AWX database. You must set this value or provide secretKeyExistingSecret |
| secretKeyExistingSecret | string | `nil` | The name of an existing secret in the same namespace containing a SECRET_KEY key and value |
| secret_key | string | `nil` |  |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccountName | string | `nil` | Existing service account name for AWX pods to use (optional) |
| task.extraVolumeMounts | list | `[]` |  |
| task.resources | object | `{}` |  |
| tolerations | string | `nil` |  |
| web.extraVolumeMounts | list | `[]` |  |
| web.extraVolumes | list | `[]` |  |
| web.resources | object | `{}` |  |

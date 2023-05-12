<!--
STOP! README.md is automatically generated using helm-docs
Run `helm-docs .` to generate.
If you're looking at README.md.gotmpl, then you're in the right place.
-->
# Contribsys Faktory

![Version: 0.12.3](https://img.shields.io/badge/Version-0.12.3-informational?style=flat-square) ![AppVersion: 1.6.0](https://img.shields.io/badge/AppVersion-1.6.0-informational?style=flat-square)

A Helm chart for deploying Faktory

**Homepage:** <https://github.com/contribsys/faktory>

# Faktory Helm Chart

At a high level, [Faktory](https://github.com/contribsys/faktory) is a work server. It is the repository for background jobs within your application. Jobs have a type and a set of arguments and are placed into queues for workers to fetch and execute.

You can use this server to distribute jobs to one or hundreds of machines. Jobs can be executed with any language by clients using the Faktory API to fetch a job from a queue.

## Installing charts from this repo

In order to install charts from this repository, you'll first need to add this repository.

Add the repo named `adwerx` with the command below:

```bash
helm repo add adwerx https://adwerx.github.io/charts
```

## Installation

Add our repo:

```bash
helm repo add adwerx https://adwerx.github.io/charts
```

Install the chart:

```bash
helm install adwerx/faktory
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| jbielick |  |  |

## Source Code

* <https://github.com/contribsys/faktory>
* <https://github.com/AdWerx/charts/tree/master/faktory>

## Requirements

Kubernetes: `>= 1.9.0-0`

## Faktory Configuration Changes

You can add Faktory configuration to the `config` value. Each key will become the file name and the value should be a heredoc of file contents. See examples in the values.yaml for more info. Ensure that they end in `.toml` and Faktory will read all of these files from a `ConfigMap`. Changes to these files are typically propogated to Faktory in less than a minute.

Config changes are hot-reloaded by Faktory with a `SIGHUP` signal.

Why not `inotify` watch for config changes?

https://github.com/kubernetes/kubernetes/issues/24215

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config | string | `nil` | A ConfigMap structure of config file names (keys) and config file contents (values). |
| environment | string | `"production"` | The Faktory server environment |
| extraEnv | object | `{}` | key-value map of variables to define |
| global.faktory | object | `{}` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"contribsys/faktory"` |  |
| image.tag | string | `"1.5.1"` |  |
| licenseExistingSecret | object | `{"key":null,"name":null}` | Use a key from an existing secret for the faktory pro license |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `6` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| metrics.enabled | bool | `false` | Whether to enable third-party prometheus exporter for faktory metrics |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.repository | string | `"envek/faktory_exporter"` |  |
| metrics.image.tag | string | `"0.4.1"` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `nil` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.namespace | string | `nil` | Specify a namespace if needed and fallback to the prometheus default unless specified |
| nodeSelector | object | `{}` |  |
| password | string | `nil` | Set a password for faktory using this variable or passwordExistingSecret |
| passwordExistingSecret | object | `{"key":null,"name":null}` | Use a key from an existing secret for the faktory password |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.size | string | `"8Gi"` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `6` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{"capabilities":{"add":["SYS_PTRACE"]}}` | You may need the following settings to be able to write to the persistent disk your cloud provider attaches for the PVC. If Faktory fails to start with a permission error writing to disk in environments such as GKE, this may solve the issue. |
| server | object | `{}` |  |
| tolerations | list | `[]` |  |
| ui.enabled | bool | `true` | Whether to run the Faktory web UI or not |
| ui.ingress.annotations | object | `{}` |  |
| ui.ingress.enabled | bool | `false` |  |
| ui.ingress.hosts | list | `[]` |  |
| ui.ingress.tls | list | `[]` |  |
| ui.service.port | int | `7420` |  |
| ui.service.type | string | `"ClusterIP"` |  |
| updateStrategy | string | `"OnDelete"` | NOTE! In order to avoid unexpected downtime, pods **will not** be automatically rolled out when the spec changes, you must delete the faktory pod for it to be recreated. Choose `RollingUpdate` if you'd prefer for kubernetes to replace the pod for you automatically--this will incur some downtime and thus is not automated. If you're only changing the faktory configs, you need not delete the pod—Faktory will hot reload the changes. |

## Examples

### Expose Faktory Web UI on subpath

If your cluster is using Nginx Ingress controller, then you can use [configuration snippet](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#configuration-snippet) to specify `X-Script-Name` header.

```yaml
ui:
  ingress:
    enabled: true
    hosts:
      - host: example.com
        paths:
          - path: /faktory
            pathType: ImplementationSpecific
    annotations:
      nginx.ingress.kubernetes.io/configuration-snippet: |
        proxy_set_header X-Script-Name /faktory;
```

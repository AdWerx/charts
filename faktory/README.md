# Faktory Helm Chart

At a high level, [Faktory](https://github.com/contribsys/faktory) is a work server. It is the repository for background jobs within your application. Jobs have a type and a set of arguments and are placed into queues for workers to fetch and execute.

You can use this server to distribute jobs to one or hundreds of machines. Jobs can be executed with any language by clients using the Faktory API to fetch a job from a queue.

## Installing charts from this repo

In order to install charts from this repository, you'll first need to add this repository.

Add the repo named `adwerx` with the command below:

```bash
helm repo add adwerx https://adwerx.github.io/charts
```

## TL;DR;

```bash
$ helm install adwerx/faktory
```

## Installing the Chart

To install the chart with the release name `faktory`:

```bash
$ helm install --name faktory adwerx/faktory
```

The command above deploys Faktory on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `faktory` deployment:

```bash
$ helm delete faktory
```

The command above removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Faktory chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`image.registry` | Faktory image registry | `docker.io`
`image.repository` | Faktory image repository | `contribsys/faktory`
`image.tag` | Faktory image tag | `1.0.1`
`image.pullPolicy` | Faktory image pullPolicy | `IfNotPresent`
`image.pullSecrets` | Image pull secret names for pulling private images | `[]`
`password` | Faktory server password (required in environment=production) | `(random)`
`passwordExistingSecret.name` | (optional) Name of an existing secret to use for the Faktory password | `nil`
`passwordExistingSecret.key` | (optional) Name of a key within an existing secret to use for the Faktory password | `nil`
`license` | Faktory Pro/Enterprise license | `nil`
`licenseExistingSecret.name` | (optional) Name of an existing secret to use for the Faktory license | `nil`
`licenseExistingSecret.key` | (optional) Name of a key within an existing secret to use for the Faktory license | `nil`
`ui.enabled` | Expose the Faktory UI in the service | `true`
`ui.service.type` | Faktory server service type | `ClusterIP`
`ui.service.port` | UI service port for Faktory WebUI | `7420`
`ui.ingress.enabled` | If true, an ingress will be created for the Faktory UI | `false`
`ui.ingress.annotations` | Ingress annotations | `{}`
`ui.ingress.hosts` | Ingress hostnames and paths. E.g. `[{ host: "example.com", path: "/faktory" }]` | `[]`
`ui.ingress.tls` | Ingress TLS configuration | `[]`
`extraEnv` | Key-value map of additional ENV variables to set on the Faktory container | `{}`
`resources` | Resource requests and limits | `{}`
`nodeSelector` | Node selector labels for pod assignment | `{}`
`tolerations` | Toleration for pod assignment | `[]`
`affinity` | Affinity for pod assignment | `{}`
`persistence.enabled` | Enable persistent storage via PVC | `true`
`persistence.existingClaim` | (optional) Name of an existing PVC to use for persistence | ``
`persistence.size` | Size of persistent volume to allocate | `8Gi`
`persistence.accessModes` | Persistent Volume access modes | `["ReadWriteOnce"]`
`persistence.annotations` | Annotations for Persistent Volume Claim | `{}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install adwerx/faktory --name faktory --set password=mysecurepassword
```

A YAML file that defines values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install adwerx/faktory --name faktory -f my_values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Faktory Configuration Changes

You can add Faktory configuration to the `config` value. Each key will become the file name and the value should be a heredoc of file contents. See examples in the values.yaml for more info. Ensure that they end in `.toml` and Faktory will read all of these files from a `ConfigMap`. Changes to these files are typically propogated to Faktory in less than a minute.

Config changes are hot-reloaded by Faktory with a `SIGHUP` signal.

Why not `inotify` watch for config changes?

https://github.com/kubernetes/kubernetes/issues/24215

## Examples

### Expose Faktory Web UI on subpath

If your cluster is using Nginx Ingress controller, then you can use [configuration snippet](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#configuration-snippet) to specify `X-Script-Name` header.

```yaml
ui:
  ingress:
    enabled: yes
    hosts:
      - host: example.com
        paths:
          - /faktory
    annotations:
      nginx.ingress.kubernetes.io/configuration-snippet: |
        proxy_set_header X-Script-Name /faktory;
```

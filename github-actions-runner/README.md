<!--
STOP! README.md is automatically generated using helm-docs
Run `helm-docs .` to generate.
If you're looking at README.md.gotmpl, then you're in the right place.
-->
# github-actions-runner

![Version: 0.9.1](https://img.shields.io/badge/Version-0.9.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.274.2-20.04-4](https://img.shields.io/badge/AppVersion-2.274.2--20.04--4-informational?style=flat-square)

Deploys a StatefulSet of [GitHub Actions self-hosted runners](https://github.com/actions/runner)—
allowing you to run your [GitHub Actions](https://github.com/features/actions) workflows on your
own infrastructure.

## Requirements

- Kubernetes >1.14
- Helm ~3

## Runner Registration (Authentication)

This chart intentionally avoids using a GitHub Personal Access Token with `admin:org` privileges. As such, you will need to provide a runner registration token upon chart installation and when increasing the replica count.

**⚠️ Important: Follow these steps to setup your runners correctly**.

#### Registration Tokens

An Actions Runner must _register_ before obtaining the credentials necessary to perform actions. Registration is accomplished by calling the GitHub-provided `config.sh` script with a _registration token_. Once a runner has registered, it no longer needs the registration token. Please be sure to provide a registration token to this chart via values (`runner.registrationToken`) _before_ the token expires.

#### Obtaining a registration token

[**ℹ️ Note: Registration tokens expire in 1 hour**](https://github.community/t/api-to-generate-runners-token/16963/8)

A registration token is provided when selecting "Add new" -> "New Runner" in the GitHub UI as described in [the "Adding self-hosted runners" documentation](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/adding-self-hosted-runners).

#### Using a registration token with this chart

A registration token can be used to register multiple runners before its expiry. Therefore, this chart utilizes one registration token to register as many runners as the highest of these values: `replicaCount` or `autoscaling.maxReplicas`.

When autoscaling is disabled, the registration token will be used as many as `replicaCount` times to register runners (each pod). After registration, the long-lived runner credentials for each pod are stored on its persistent volume so that the runner pod can be rescheduled or restarted and resume working again without registering again.

When autoscaling is enabled, it is necessary to use the registration token immediately to obtain `autoscaling.maxReplicas` long-lived runner credentials so that the registration token may expire and as many as `autoscaling.maxReplicas` long-lived runner credentials have been saved to persistent volumes and can be started as needed.

## Installation

```
helm repo add adwerx https://adwerx.github.io/charts

# ...obtain a registration token

helm install github-actions-runner adwerx/github-actions-runner \
  --set runner.registrationToken=ABCDEF123
```

## Docker Actions

Some actions require the use of a docker daemon to run containers. To enable the docker-in-docker daemon sidecar, set `dind.enabled=true` in your values. The docker daemon sidecar runs as a `privileged` container by default. By using this feature you must understand its inherent risk.

### How do I use my own docker remote host?

You can provide a `DOCKER_HOST` env variable to the runner with `runner.extraEnv`:

```yaml
runner:
  extraEnv:
    - name: DOCKER_HOST
      value: tcp://dind.default.svc.cluster.local
```

### Can I use my own docker image for the runner?

Sure. The Dockerfile for the image used in this chart can be found [here](https://github.com/AdWerx/dockerfiles/tree/main/github-actions-runner). You can base your image on that one, or make sure that your custom image has a `WORKDIR` of `/home/actions/runner` and the actions runner package is installed there.

## Raison d'être (Reason for existence)

There are existing GitHub Action Runner charts and/or images that exist that may be more useful.

While this chart duplicates some of that work, it differentiates in a few important ways:

- This chart does not require or use a GitHub Personal Access Token

Use of this token for obtaining runner registration tokens requires `admin:org` scope, which is high-privelege. While slightly less automated, the process of using a registration token is fairly simple.

- Docker-in-Docker via `dind` daemon

Instead of installing docker inside of the GitHub Actions Runner container itself, this runs a `docker:dind` sidecar and communicates over `localhost`. To share a filesystem and work with the runner workspace as expected, the workspace volume is mounted to both containers in the pod.

### Why a StatefulSet?

Runners are stateful! That is, they need a short-lived registration token in order to register themselves, but after that point, they store their own credentials on disk. To preserve the runner credentials on disk for each pod, we use a persistent volume claim per pod, so each pod can be rescheduled or restarted and when started, can authenticate by itself (without the registration token) and continue working.

The token provided when using "add new runner" in the UI is a temporary registration token that can be used to register an actions runner. Once the runner is registered (using config.sh), it stores its own credentials locally. The registration token is short-lived (1 hour) and cannot be renewed. But after registration is complete, the runner should be able to continue to stay authenticated using its own credentials.

So where does the runner store credentials? ./.runner, ./.credentials, etc, local to the run.sh and config.sh script. Because they're local to the scripts, we can't mount a volume on top of the scripts, so we copy the scripts to a volume directory and allow the registration credentials to be written alongside the scripts inside the volume. Thus, when the runner restarts, it doesn't need to re-register, it simply reconnects with existing credentials.

### Alternatives

- [lazybit/actions-runner](https://github.com/lazybit-ch/actions-runner/tree/master/actions-runner)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `4` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `50` |  |
| dind.enabled | bool | `false` | If you'd like your runner to be docker-enabled and you understand and accept the security risks associated with a priveleged container running actions, enable here |
| dind.image.pullPolicy | string | `"IfNotPresent"` |  |
| dind.image.repository | string | `"docker"` |  |
| dind.image.tag | string | `"19.03.13-dind"` |  |
| dind.resources | object | `{}` |  |
| dind.securityContext.privileged | bool | `true` |  |
| fullnameOverride | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` | Highly recommended so runners can retain their registration and renew tokens automatically |
| persistence.size | string | `"8Gi"` |  |
| podAnnotations | object | `{}` |  |
| podManagementPolicy | string | `"Parallel"` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| replicaCount | int | `1` | If not using autoscaling, set the desired runner count |
| runner.extraEnv | list | `[]` |  |
| runner.image.pullPolicy | string | `"IfNotPresent"` |  |
| runner.image.repository | string | `"adwerx/github-actions-runner"` |  |
| runner.image.tag | string | `""` | Default is the chart appVersion. |
| runner.labels | string | `""` | Optional labels for the runner to match against in your workflows |
| runner.name | string | `""` | Set if you want custom runner names. Defaults to the pod name |
| runner.registrationToken | string | `""` | The registration token obtained from GitHub's "Add new runner" |
| runner.resources | object | `{}` |  |
| runner.scope | string | `""` | Either `myorg` or `myorg/myrepo` for an organization-scoped runner or repo-scoped runner, respectively. |
| runner.securityContext | object | `{}` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` |  |

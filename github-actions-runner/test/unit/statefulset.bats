#!/usr/bin/env bats

load _helpers

name="statefulset"

@test "$name: replicas is 1" {
  template $name

  local actual=$(get '.spec.replicas')
  assert_equal "${actual}" "1"
}

@test "$name: replicas is set via values" {
  template $name --set=replicaCount=4

  local actual=$(get '.spec.replicas')
  assert_equal "${actual}" "4"
}

@test "$name: podManagementPolicy is set via Values" {
  template $name

  local actual=$(get '.spec.podManagementPolicy')
  assert_equal "${actual}" "Parallel"

  template $name --set=podManagementPolicy=OrderedReady

  local actual=$(get '.spec.podManagementPolicy')
  assert_equal "${actual}" "OrderedReady"
}

@test "$name: pod annotations are added" {
  template $name --set 'podAnnotations.key=value'

  local actual=$(get '.spec.template.metadata.annotations.key')
  assert_equal "${actual}" "value"
}

@test "$name: selector labels match pod labels" {
  template $name

  local selectorLabels=$(get '.spec.selector.matchLabels')
  local podLabels=$(get '.spec.template.metadata.labels')
  assert_equal "${selectorLabels}" "${podLabels}"
}

@test "$name: imagePullSecrets are added" {
  template $name --set 'imagePullSecrets[0].name=mykey'

  local actual=$(get '.spec.template.spec.imagePullSecrets[0].name')
  assert_equal "${actual}" "mykey"
}

@test "$name: serviceAccountName is set via values" {
  template $name --set serviceAccount.create=true --set serviceAccount.name=myaccount

  local actual=$(get '.spec.template.spec.serviceAccountName')
  assert_equal "${actual}" "myaccount"
}

@test "$name: RUNNER_SCOPE is set in initContainer ENV" {
  template $name --set runner.scope=myorg

  local env_name=$(get '.spec.template.spec.initContainers[0].env[0].name')
  assert_equal "${env_name}" "RUNNER_SCOPE"
  local env_value=$(get '.spec.template.spec.initContainers[0].env[0].value')
  assert_equal "${env_value}" "myorg"
}

@test "$name: RUNNER_NAME is set in initContainer ENV" {
  template $name --set runner.name=myrunner

  local env_name=$(get '.spec.template.spec.initContainers[0].env[1].name')
  assert_equal "${env_name}" "RUNNER_NAME"
  local env_value=$(get '.spec.template.spec.initContainers[0].env[1].value')
  assert_equal "${env_value}" "myrunner"
}

@test "$name: RUNNER_LABELS is set in initContainer ENV" {
  template $name --set runner.labels='one two three'

  local env_name=$(get '.spec.template.spec.initContainers[0].env[2].name')
  assert_equal "${env_name}" "RUNNER_LABELS"
  local env_value=$(get '.spec.template.spec.initContainers[0].env[2].value')
  assert_equal "${env_value}" "one two three"
}

@test "$name: has a checksum of the secret template" {
  template $name

  output=$(get '.spec.template.metadata.annotations["checksum/token"]')
  assert_output --regexp '^[a-zA-Z0-9]{64}$'
}

@test "$name: runner.extraEnv is added" {
  template $name \
    --set 'runner.extraEnv[0].name=DOCKER_HOST' \
    --set 'runner.extraEnv[0].value=dind.default.svc.cluster.local'

  local env_name=$(get '.spec.template.spec.containers[0].env[0].name')
  assert_equal "${env_name}" "DOCKER_HOST"
  local env_value=$(get '.spec.template.spec.containers[0].env[0].value')
  assert_equal "${env_value}" "dind.default.svc.cluster.local"
}

# allow dockerHost to be set

@test "$name: initContainer gets registration token" {
  template "secret"

  local secretName=$(get '.metadata.name')
  local keyName=$(get '.data | keys | .[0]')

  template $name --set registrationToken=abc

  local actual=$(get '.spec.template.spec.initContainers[0].env[3].valueFrom.secretKeyRef.name')
  assert_equal "${actual}" "${secretName}"
  local actual=$(get '.spec.template.spec.initContainers[0].env[3].valueFrom.secretKeyRef.key')
  assert_equal "${actual}" "${keyName}"
}

@test "$name: custom runner image can be provided" {
  template $name --set runner.image.repository=myorg/runner --set runner.image.tag=2.272.3

  local actual=$(get '.spec.template.spec.containers[0].image')
  assert_equal "${actual}" "myorg/runner:2.272.3"
}

@test "$name: dind is disabled by default" {
  template $name

  local actual=$(get '.spec.template.spec.containers' | yq '. | length')
  assert_equal "${actual}" "1"

  local actual=$(get '.spec.template.spec.containers[0].name')
  assert_equal "${actual}" "runner"
}

@test "$name: dind sidecar is added" {
  template $name --set=dind.enabled=true

  local container_count=$(get '.spec.template.spec.containers' | yq '. | length')
  assert_equal "${container_count}" "2"

  local first_name=$(get '.spec.template.spec.containers[0].name')
  assert_equal "${first_name}" "runner"

  local second_name=$(get '.spec.template.spec.containers[1].name')
  assert_equal "${second_name}" "dind-daemon"

  local privileged=$(get '.spec.template.spec.containers[1].securityContext.privileged')
  assert_equal "${privileged}" "true"
}

@test "$name: dind daemon host endpoint is provided to runner" {
  template $name --set=dind.enabled=true

  local name=$(get '.spec.template.spec.containers[0].env[0].name')
  assert_equal "${name}" "DOCKER_HOST"

  local host=$(get '.spec.template.spec.containers[0].env[0].value')
  assert_equal "${host}" "tcp://localhost:2375"
}

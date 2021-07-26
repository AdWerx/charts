#!/usr/bin/env bats

load "../_helpers"

name="statefulset"

@test "$name: replicas is one"  {
  template $name

  get '.spec.replicas'
  [ "$got" = "1" ]
}

@test "$name: uses correct faktory image tag"  {
  template $name

  get '.spec.template.spec.containers[1].image'
  [ "$got" = "docker.io/contribsys/faktory:1.5.1" ]
}

@test "$name: uses correct command" {
  template $name

  get '.spec.template.spec.containers[1].command'
  [ "$got" = '[
  "/faktory",
  "-b",
  ":7419",
  "-w",
  ":7420",
  "-e",
  "production"
]' ]
}

@test "$name: uses existing secret by name" {
  template $name \
    --set "passwordExistingSecret.name=mysecret" \
    --set "passwordExistingSecret.key=passwordy"

  get '.spec.template.spec.containers[1].env[0].name'
  [ "$got" = "FAKTORY_PASSWORD" ]
  get '.spec.template.spec.containers[1].env[0].valueFrom.secretKeyRef.name'
  [ "$got" = "mysecret" ]
  get '.spec.template.spec.containers[1].env[0].valueFrom.secretKeyRef.key'
  [ "$got" = "passwordy" ]
}

@test "$name: uses existing license by name" {
  template $name \
    --set "licenseExistingSecret.name=mysecret" \
    --set "licenseExistingSecret.key=license"

  get '.spec.template.spec.containers[1].env[1].name'
  [ "$got" = "FAKTORY_LICENSE" ]
  get '.spec.template.spec.containers[1].env[1].valueFrom.secretKeyRef.name'
  [ "$got" = "mysecret" ]
  get '.spec.template.spec.containers[1].env[1].valueFrom.secretKeyRef.key'
  [ "$got" = "license" ]
}

@test "$name: uses existing claim by name" {
  template $name \
    --set "persistence.existingClaim=mydata"

  get '.spec.template.spec.volumes[1].persistentVolumeClaim.claimName'
  [ "$got" = "mydata" ]
}

@test "$name: mounts configs at correct directory" {
  template $name

  get '.spec.template.spec.volumes[0].name'
  [ "$got" = "configs" ]
  get '.spec.template.spec.volumes[0].configMap.name'
  [ "$got" = "RELEASE-NAME-faktory" ]
  get '.spec.template.spec.containers[0].volumeMounts[0].name'
  [ "$got" = "configs" ]
  get '.spec.template.spec.containers[0].volumeMounts[0].mountPath'
  [ "$got" = "/conf" ]
  get '.spec.template.spec.containers[1].volumeMounts[1].name'
  [ "$got" = "configs" ]
  get '.spec.template.spec.containers[1].volumeMounts[1].mountPath'
  [ "$got" = "/etc/faktory/conf.d" ]
}

@test "$name: mounts data at correct directory" {
  template $name

  get '.spec.volumeClaimTemplates[0].metadata.name'
  [ "$got" = "data" ]
  get '.spec.volumeClaimTemplates[0].spec.accessModes[0]'
  [ "$got" = "ReadWriteOnce" ]
  get '.spec.template.spec.containers[1].volumeMounts[0].name'
  [ "$got" = "data" ]
  get '.spec.template.spec.containers[1].volumeMounts[0].mountPath'
  [ "$got" = "/var/lib/faktory" ]
}

@test "$name: Uses apps/v1 api" {
  template $name

  get '.apiVersion'
  [ "$got" = "apps/v1" ]
}

@test "$name: Default environment is production" {
  template $name

  get '.spec.template.spec.containers[] | select(.name == "server") | .command | join(" ") | contains("-e production")'
  [ "$got" = "true" ]
}

@test "$name: Allows setting the faktory environment" {
  template $name --set environment=staging

  get '.spec.template.spec.containers[] | select(.name == "server") | .command | join(" ") | contains("-e staging")'
  [ "$got" = "true" ]
}

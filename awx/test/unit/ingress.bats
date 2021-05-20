#!/usr/bin/env bats

load _helpers

name="ingress"

@test "$name: is disabled by default" {
  template $name

  [ "$status" -eq 1 ]
  [ "$output" = "Error: could not find template templates/ingress.yaml in chart" ]
}

@test "$name: can be enabled" {
  template $name --set="ingress.enabled=true"

  [ "$status" -eq 0 ]
  local actual=$(get '.kind')
  [ "$actual" = "Ingress" ]
}

@test "$name: uses defaultBackend by default" {
  template $name --set="ingress.enabled=true"

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.backend.serviceName')
  [ "$actual" = "RELEASE-NAME-awx" ]
  local actual=$(get '.spec.backend.servicePort')
  [ "$actual" = "http" ]
}

@test "$name: allows host rules" {
  template $name --values `valuesPath ingress-host`

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.backend.serviceName')
  [ "$actual" = "null" ]
  local actual=$(get '.spec.rules[0].host')
  [ "$actual" = "awx.example.com" ]
  local actual=$(get '.spec.rules[0].http.paths[0].path')
  [ "$actual" = "/" ]
  local actual=$(get '.spec.rules[0].http.paths[0].backend.serviceName')
  [ "$actual" = "RELEASE-NAME-awx" ]
  local actual=$(get '.spec.rules[0].http.paths[0].backend.servicePort')
  [ "$actual" = "http" ]
}

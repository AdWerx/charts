#!/usr/bin/env bats

load ../_helpers

name="ingress"

@test "$name: is disabled by default" {
  template_with_defaults $name

  [ "$status" -eq 1 ]
  [ "$output" = "Error: could not find template templates/ingress.yaml in chart" ]
}

@test "$name: can be enabled" {
  template_with_defaults $name --set="ingress.enabled=true"

  [ "$status" -eq 0 ]
  local actual=$(get '.kind')
  [ "$actual" = "Ingress" ]
}

@test "$name: uses defaultBackend by default" {
  template_with_defaults $name --set="ingress.enabled=true"

  [ "$status" -eq 0 ]
  [ "$(get '.spec.defaultBackend.service.name')" = "RELEASE-NAME-awx" ]
  [ "$(get '.spec.defaultBackend.service.port.name')" = "http" ]
}

@test "$name: (kube >=1.19.0) uses defaultBackend by default" {
  template_with_defaults $name --set="ingress.enabled=true" --kube-version 1.19.1

  [ "$status" -eq 0 ]
  [ "$(get '.spec.defaultBackend.service.name')" = "RELEASE-NAME-awx" ]
  [ "$(get '.spec.defaultBackend.service.port.name')" = "http" ]
}

@test "$name: (kube <1.19.0) uses backend by default" {
  template_with_defaults $name --set="ingress.enabled=true" --kube-version 1.18.3

  [ "$status" -eq 0 ]
  [ "$(get '.spec.backend.serviceName')" = "RELEASE-NAME-awx" ]
  [ "$(get '.spec.backend.servicePort')" = "http" ]
}

@test "$name: allows host rules" {
  template_with_defaults $name --values `valuesPath ingress-host`

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.backend.service.name')
  [ "$actual" = "null" ]
  local actual=$(get '.spec.rules[0].host')
  [ "$actual" = "awx.example.com" ]
  local actual=$(get '.spec.rules[0].http.paths[0].path')
  [ "$actual" = "/" ]
  local actual=$(get '.spec.rules[0].http.paths[0].backend.service.name')
  [ "$actual" = "RELEASE-NAME-awx" ]
  local actual=$(get '.spec.rules[0].http.paths[0].backend.service.port.name')
  [ "$actual" = "http" ]
}

@test "$name: (kube >=1.19.0) allows host rules" {
  template_with_defaults $name --values `valuesPath ingress-host` --kube-version 1.19.1

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.backend.service.name')
  [ "$actual" = "null" ]
  local actual=$(get '.spec.rules[0].host')
  [ "$actual" = "awx.example.com" ]
  local actual=$(get '.spec.rules[0].http.paths[0].path')
  [ "$actual" = "/" ]
  local actual=$(get '.spec.rules[0].http.paths[0].backend.service.name')
  [ "$actual" = "RELEASE-NAME-awx" ]
  local actual=$(get '.spec.rules[0].http.paths[0].backend.service.port.name')
  [ "$actual" = "http" ]
}

@test "$name: (kube <1.19.0) allows host rules" {
  template_with_defaults $name --values `valuesPath ingress-host` --kube-version 1.18.3

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

@test "$name: uses stable networking api"  {
  template_with_defaults $name --set="ingress.enabled=true"

  [ "$(get '.apiVersion')" = "networking.k8s.io/v1" ]
}

@test "$name: (kube >=1.19.0) uses stable networking api"  {
  template_with_defaults $name --set="ingress.enabled=true" --kube-version 1.19.1

  [ "$(get '.apiVersion')" = "networking.k8s.io/v1" ]
}

@test "$name: (kube <1.19.0) uses networking.k8s.io/v1beta1"  {
  template_with_defaults $name --set="ingress.enabled=true" --kube-version 1.18.3

  [ "$(get .apiVersion)" = "networking.k8s.io/v1beta1" ]
}

@test "$name: serviceName and servicePort match UI service"  {
  template_with_defaults "web-service"

  expected_name="$(get '.metadata.name')"
  expected_port="$(get '.spec.ports[0].name')"

  template_with_defaults $name --values `valuesPath ingress-host`

  actual_name=$(get '.spec.rules[0].http.paths[0].backend.service.name')
  [ "$actual_name" = "$expected_name" ]
  actual_port=$(get '.spec.rules[0].http.paths[0].backend.service.port.name')
  [ "$actual_port" = "$expected_port" ]
}

@test "$name: (kube >=1.19.0) serviceName and servicePort match UI service"  {
  template_with_defaults "web-service"

  expected_name="$(get '.metadata.name')"
  expected_port="$(get '.spec.ports[0].name')"

  template_with_defaults $name --values `valuesPath ingress-host` --kube-version 1.19.1

  actual_name=$(get '.spec.rules[0].http.paths[0].backend.service.name')
  [ "$actual_name" = "$expected_name" ]
  actual_port=$(get '.spec.rules[0].http.paths[0].backend.service.port.name')
  [ "$actual_port" = "$expected_port" ]
}

@test "$name: (kube <1.19.0) serviceName and servicePort match UI service"  {
  template_with_defaults "web-service"

  expected_name="$(get ".metadata.name")"
  expected_port="$(get ".spec.ports[0].name")"

  template_with_defaults $name --values `valuesPath ingress-host` --kube-version 1.18.3

  actual_name=$(get '.spec.rules[0].http.paths[0].backend.serviceName')
  [ "$actual_name" = "$expected_name" ]
  actual_port=$(get '.spec.rules[0].http.paths[0].backend.servicePort')
  [ "$actual_port" = "$expected_port" ]
}

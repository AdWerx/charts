#!/usr/bin/env bats

load "../_helpers"

name="ui-ingress"

@test "$name: allows input of host and subpath"  {
  template $name -f $(valuesPath ingress)

  get '.spec.rules[0].host'
  [ "$got" = "example.com" ]
  get '.spec.rules[0].http.paths[0].path'
  [ "$got" = "/subpath" ]
}

@test "$name: serviceName and servicePort match UI service"  {
  template "ui-service"

  get ".metadata.name"
  service_name="$got"

  get ".spec.ports[0].name"
  service_port="$got"

  template $name -f $(valuesPath ingress)

  get '.spec.rules[0].http.paths[0].backend.serviceName'
  [ "$got" = "$service_name" ]
  get '.spec.rules[0].http.paths[0].backend.servicePort'
  [ "$got" = "$service_port" ]
}

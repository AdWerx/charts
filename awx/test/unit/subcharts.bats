#!/usr/bin/env bats

load _helpers

@test "subcharts: memcached statefulset is apiVersion apps/v1"  {
  cd `chart_dir`

  run_debug helm template -s charts/memcached/templates/statefulset.yaml .

  local actual=$(get '.apiVersion')

  [ "$actual" = "apps/v1" ]
}

@test "subcharts: postgresql statefulset is apiVersion apps/v1"  {
  cd `chart_dir`

  run_debug helm template -s charts/postgresql/templates/statefulset.yaml .

  local actual=$(get '.apiVersion')

  [ "$actual" = "apps/v1" ]
}

@test "subcharts: rabbitmq statefulset is apiVersion apps/v1"  {
  cd `chart_dir`

  run_debug helm template -s charts/rabbitmq/templates/statefulset.yaml .

  local actual=$(get '.apiVersion')

  [ "$actual" = "apps/v1" ]
}

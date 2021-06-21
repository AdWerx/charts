#!/usr/bin/env bats

load _helpers

@test "subcharts: postgresql statefulset is apiVersion apps/v1"  {
  cd `chart_dir`

  run_debug helm template -f $(valuesPath test-defaults) -s charts/postgresql/templates/statefulset.yaml .

  local actual=$(get '.apiVersion')

  [ "$actual" = "apps/v1" ]
}

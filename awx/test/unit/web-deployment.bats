#!/usr/bin/env bats

load _helpers

@test "Deployment: replicas is one"  {
  template web-deployment

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.spec.replicas' | tee /dev/stderr)
  [ "$actual" = 1 ]
}

@test "Deployment: uses correct image tag"  {
  template web-deployment

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[0].image')
  [ "$actual" = "ansible/awx_web:8.0.0" ]
}

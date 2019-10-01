#!/usr/bin/env bats

load _helpers

@test "Deployment: replicas is one"  {
  template deployment

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.spec.replicas' | tee /dev/stderr)
  [ "$actual" = 1 ]
}

@test "Deployment: uses 7.0.0 image tag"  {
  template deployment

  [ "$status" -eq 0 ]
  [ "$(echo "$output" | yq -r '.spec.template.spec.containers[0].image')" = "ansible/awx_web:7.0.0" ]
  [ "$(echo "$output" | yq -r '.spec.template.spec.containers[1].image')" = "ansible/awx_task:7.0.0" ]
}

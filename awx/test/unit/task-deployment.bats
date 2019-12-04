#!/usr/bin/env bats

load _helpers

name="task-deployment"

@test "$name: replicas is one"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.replicas')
  [ "$actual" = 1 ]
}

@test "$name: uses correct image tag"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[0].image')
  [ "$actual" = "ansible/awx_task:8.0.0" ]
}

@test "$name: uses correct command" {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[0].command[0]')
  [ "$actual" = "/usr/bin/launch_awx_task.sh" ]
}

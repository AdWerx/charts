#!/usr/bin/env bats

load _helpers

name="deployment"

@test "$name: replicas is one"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.replicas')
  [ "$actual" = 1 ]
}

@test "$name: web uses correct image tag"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "web") | .image')
  [ "$actual" = "ansible/awx:16.0.0" ]
}

@test "$name: task uses correct image tag"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "task") | .image')
  [ "$actual" = "ansible/awx:16.0.0" ]
}

@test "$name: task uses correct command" {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "task") | .command[0]')
  [ "$actual" = "/usr/bin/launch_awx_task.sh" ]
}

@test "$name: mounts nginx.conf"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.volumes[3].configMap.name')
  [ "$actual" = "RELEASE-NAME-awx-settings" ]

  local actual=$(get '.spec.template.spec.volumes[3].name')
  [ "$actual" = "nginx-conf" ]

  local actual=$(get '.spec.template.spec.volumes[3].configMap.items[0].key')
  [ "$actual" = "nginx.conf" ]

  local actual=$(get '.spec.template.spec.containers[] | select(.name == "web") | .volumeMounts[0].name')
  [ "$actual" = "nginx-conf" ]

  local actual=$(get '.spec.template.spec.containers[] | select(.name == "web") | .volumeMounts[0].mountPath')
  [ "$actual" = "/etc/nginx/nginx.conf" ]

  local actual=$(get '.spec.template.spec.containers[] | select(.name == "web") | .volumeMounts[0].subPath')
  [ "$actual" = "nginx.conf" ]

  template settings-configmap
  local actual=$(get -r '.data["nginx.conf"]')
  [ $(echo "$actual" | grep listen | xargs echo) = "listen 8052 default_server;" ]
}

@test "$name: uses serviceAccountName" {
  template serviceaccount
  local real_name=$(get '.metadata.name')

  template $name "$@"

  local actual=$(get '.spec.template.spec.serviceAccountName')
  [ "$actual" = "$real_name" ]
}

@test "$name: uses provided serviceAccountName" {
  template $name "$@" --set serviceAccountName=myServiceAccount

  local actual=$(get '.spec.template.spec.serviceAccountName')
  [ "$actual" = "myServiceAccount" ]
}

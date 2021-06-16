#!/usr/bin/env bats

load ../_helpers

name="deployment"

@test "$name: replicas is one"  {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.replicas')
  [ "$actual" = 1 ]
}

@test "$name: web uses correct image tag"  {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "web") | .image')
  [ "$actual" = "ansible/awx:16.0.0" ]
}

@test "$name: task uses correct image tag"  {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "task") | .image')
  [ "$actual" = "ansible/awx:16.0.0" ]
}

@test "$name: task uses correct command" {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "task") | .command[0]')
  [ "$actual" = "/usr/bin/launch_awx_task.sh" ]
}

@test "$name: mounts nginx.conf"  {
  template_with_defaults $name

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

  template_with_defaults settings-configmap
  local conf_data=$(get -r '.data["nginx.conf"]')
  local actual=$(echo "$conf_data" | grep listen | xargs echo)
  [ "$actual" = "listen 8052 default_server;" ]
}

@test "$name: uses serviceAccountName" {
  template_with_defaults serviceaccount
  local real_name=$(get '.metadata.name')

  template_with_defaults $name "$@"

  local actual=$(get '.spec.template.spec.serviceAccountName')
  [ "$actual" = "$real_name" ]
}

@test "$name: uses provided serviceAccountName" {
  template_with_defaults $name "$@" --set serviceAccountName=myServiceAccount

  local actual=$(get '.spec.template.spec.serviceAccountName')
  [ "$actual" = "myServiceAccount" ]
}

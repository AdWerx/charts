#!/usr/bin/env bats

load _helpers

name="web-deployment"

@test "$name: replicas is one"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.spec.replicas' | tee /dev/stderr)
  [ "$actual" = 1 ]
}

@test "$name: uses correct image tag"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[0].image')
  [ "$actual" = "ansible/awx_web:9.3.0" ]
}

@test "$name: mounts nginx.conf"  {
  template $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.volumes[3].configMap.name')
  [ "$actual" = "release-name-awx-settings" ]

  local actual=$(get '.spec.template.spec.volumes[3].name')
  [ "$actual" = "nginx-conf" ]

  local actual=$(get '.spec.template.spec.volumes[3].configMap.items[0].key')
  [ "$actual" = "nginx.conf" ]

  local actual=$(get '.spec.template.spec.containers[0].volumeMounts[0].name')
  [ "$actual" = "nginx-conf" ]

  local actual=$(get '.spec.template.spec.containers[0].volumeMounts[0].mountPath')
  [ "$actual" = "/etc/nginx/nginx.conf" ]

  local actual=$(get '.spec.template.spec.containers[0].volumeMounts[0].subPath')
  [ "$actual" = "nginx.conf" ]

  template settings-configmap
  local actual=$(get -r '.data["nginx.conf"]')
  [ $(echo "$actual" | grep listen | xargs echo) = "listen 8052 default_server;" ]
}

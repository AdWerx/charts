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
  [ "$actual" = "ansible/awx:17.1.0" ]
}

@test "$name: task uses correct image tag"  {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "task") | .image')
  [ "$actual" = "ansible/awx:17.1.0" ]
}

@test "$name: task uses correct command" {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.containers[] | select(.name == "task") | .command[0]')
  [ "$actual" = "/usr/bin/launch_awx_task.sh" ]
}

@test "$name: mounts nginx.conf containing correct listen port"  {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local actual=$(get '.spec.template.spec.volumes[] | select(.name == "nginx-conf") | .configMap.name')
  [ "$actual" = "RELEASE-NAME-awx-settings" ]

  local actual=$(get '.spec.template.spec.volumes[]  | select(.name == "nginx-conf") | .name')
  [ "$actual" = "nginx-conf" ]

  local actual=$(get '.spec.template.spec.volumes[]  | select(.name == "nginx-conf") | .configMap.items[0].key')
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

@test "$name: with no existingSecrets: default secret is used for AWX_ADMIN_USER" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.AWX_ADMIN_USER" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.AWX_ADMIN_USER" ]
}

@test "$name: with no existingSecrets: default secret is used for AWX_ADMIN_PASSWORD" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.AWX_ADMIN_PASSWORD" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.AWX_ADMIN_PASSWORD" ]
}

@test "$name: with no existingSecrets: default secret is used for DATABASE_NAME" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_NAME").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_NAME" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_NAME").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_NAME" ]
}

@test "$name: with no existingSecrets: default secret is used for DATABASE_HOST" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_HOST").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_HOST" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_HOST").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_HOST" ]
}

@test "$name: with no existingSecrets: default secret is used for DATABASE_PORT" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PORT").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_PORT" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PORT").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_PORT" ]
}

@test "$name: with no existingSecrets: default secret is used for DATABASE_USER" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_USER" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_USER" ]
}

@test "$name: with no existingSecrets: default secret is used for DATABASE_PASSWORD" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_PASSWORD" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_PASSWORD" ]
}

@test "$name: with no existingSecrets: default secret is used for DATABASE_ADMIN_PASSWORD" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_ADMIN_PASSWORD" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.DATABASE_ADMIN_PASSWORD" ]
}

@test "$name: with no existingSecrets: default secret is used for SECRET_KEY" {
  template_with_defaults "$name"
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "SECRET_KEY").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.SECRET_KEY" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "SECRET_KEY").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "RELEASE-NAME-awx.SECRET_KEY" ]
}

@test "$name: with defaultAdminExistingSecret: provided secret is used for AWX_ADMIN_USER" {
  template_with_defaults "$name" --set defaultAdminExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.AWX_ADMIN_USER" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.AWX_ADMIN_USER" ]
}

@test "$name: with defaultAdminExistingSecret: provided secret is used for AWX_ADMIN_PASSWORD" {
  template_with_defaults "$name" --set defaultAdminExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.AWX_ADMIN_PASSWORD" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "AWX_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.AWX_ADMIN_PASSWORD" ]
}

@test "$name: with postgresqlExistingSecret: provided secret is used for DATABASE_NAME" {
  template_with_defaults "$name" --set postgresqlExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_NAME").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_NAME" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_NAME").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_NAME" ]
}

@test "$name: with postgresqlExistingSecret: provided secret is used for DATABASE_HOST" {
  template_with_defaults "$name" --set postgresqlExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_HOST").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_HOST" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_HOST").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_HOST" ]
}

@test "$name: with postgresqlExistingSecret: provided secret is used for DATABASE_PORT" {
  template_with_defaults "$name" --set postgresqlExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PORT").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_PORT" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PORT").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_PORT" ]
}

@test "$name: with postgresqlExistingSecret: provided secret is used for DATABASE_USER" {
  template_with_defaults "$name" --set postgresqlExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_USER" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_USER").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_USER" ]
}

@test "$name: with postgresqlExistingSecret: provided secret is used for DATABASE_PASSWORD" {
  template_with_defaults "$name" --set postgresqlExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_PASSWORD" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_PASSWORD" ]
}

@test "$name: with postgresqlExistingSecret: provided secret is used for DATABASE_ADMIN_PASSWORD" {
  template_with_defaults "$name" --set postgresqlExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_ADMIN_PASSWORD" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "DATABASE_ADMIN_PASSWORD").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.DATABASE_ADMIN_PASSWORD" ]
}

@test "$name: with secretKeyExistingSecret: provided secret is used for SECRET_KEY" {
  template_with_defaults "$name" --set secretKeyExistingSecret=my-secret
  local envs
  envs="$(get '.spec.template.spec.containers[] | select(.name == "web").env')"
  [ "$(jq -r '.[] | select(.name == "SECRET_KEY").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.SECRET_KEY" ]
  envs="$(get '.spec.template.spec.containers[] | select(.name == "task").env')"
  [ "$(jq -r '.[] | select(.name == "SECRET_KEY").valueFrom.secretKeyRef | "\(.name).\(.key)"' <<< "$envs")" = "my-secret.SECRET_KEY" ]
}

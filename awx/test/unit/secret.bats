#!/usr/bin/env bats

load ../_helpers

name="secret"

@test "$name: is named correctly" {
  template_with_defaults "$name"

  [ "$(get '.metadata.name')" = "RELEASE-NAME-awx" ]
}

@test "$name: when defaultAdminUser is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "defaultAdminUser=xyz"

  [ "$(get '.data.AWX_ADMIN_USER' | base64 -d)" = "xyz" ]
}

@test "$name: when default_admin_user is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "default_admin_user=xyz"

  [ "$(get '.data.AWX_ADMIN_USER' | base64 -d)" = "xyz" ]
}

@test "$name: when defaultAdminPassword is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "defaultAdminPassword=xyz"

  [ "$(get '.data.AWX_ADMIN_PASSWORD' | base64 -d)" = "xyz" ]
}

@test "$name: when default_admin_password is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "default_admin_password=xyz"

  [ "$(get '.data.AWX_ADMIN_PASSWORD' | base64 -d)" = "xyz" ]
}

@test "$name: when postgresql.postgresqlDatabase is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "postgresql.postgresqlDatabase=xyz"

  [ "$(get '.data.DATABASE_NAME' | base64 -d)" = "xyz" ]
}

@test "$name: when postgresql.postgresqlHost is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "postgresql.postgresqlHost=xyz"

  [ "$(get '.data.DATABASE_HOST' | base64 -d)" = "xyz" ]
}

@test "$name: when postgresql.service.port is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "postgresql.service.port=5430"

  [ "$(get '.data.DATABASE_PORT' | base64 -d)" = "5430" ]
}

@test "$name: when postgresql.postgresqlUsername is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "postgresql.postgresqlUsername=xyz"

  [ "$(get '.data.DATABASE_USER' | base64 -d)" = "xyz" ]
}

@test "$name: when postgresql.postgresqlPassword is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "postgresql.postgresqlPassword=xyz"

  [ "$(get '.data.DATABASE_PASSWORD' | base64 -d)" = "xyz" ]
}

@test "$name: when postgresql.postgresqlPassword is provided: value is stored in default secret for admin" {
  template_with_defaults "$name" --set "postgresql.postgresqlPassword=xyz"

  [ "$(get '.data.DATABASE_ADMIN_PASSWORD' | base64 -d)" = "xyz" ]
}

@test "$name: when secretKey is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "secretKey=xyz"

  [ "$(get '.data.SECRET_KEY' | base64 -d)" = "xyz" ]
}

@test "$name: when secret_key is provided: value is stored in default secret" {
  template_with_defaults "$name" --set "secret_key=xyz"

  [ "$(get '.data.SECRET_KEY' | base64 -d)" = "xyz" ]
}

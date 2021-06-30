#!/usr/bin/env bats

load ../_helpers

name="confd-secret"

@test "$name: uses DATABASE_NAME for db config" {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local credentials=$(get '.data["credentials.py"] | @base64d')
  local database_name=$(grep NAME <<< "${credentials}" | sed -e 's,.*environ\['"'"'\(.*\)'"'"'].*,\1,' | tee /dev/stderr)
  [ "$database_name" = "DATABASE_NAME" ]
}

@test "$name: uses DATABASE_USER for db config" {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local credentials=$(get '.data["credentials.py"] | @base64d')
  local database_user=$(grep USER <<< "${credentials}" | sed -e 's,.*environ\['"'"'\(.*\)'"'"'].*,\1,' | tee /dev/stderr)
  [ "$database_user" = "DATABASE_USER" ]
}

@test "$name: uses DATABASE_PASSWORD for db config" {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local credentials=$(get '.data["credentials.py"] | @base64d')
  local database_password=$(grep PASSWORD <<< "${credentials}" | sed -e 's,.*environ\['"'"'\(.*\)'"'"'].*,\1,' | tee /dev/stderr)
  [ "$database_password" = "DATABASE_PASSWORD" ]
}

@test "$name: uses DATABASE_HOST for db config" {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local credentials=$(get '.data["credentials.py"] | @base64d')
  local database_host=$(grep HOST <<< "${credentials}" | sed -e 's,.*environ\['"'"'\(.*\)'"'"'].*,\1,' | tee /dev/stderr)
  [ "$database_host" = "DATABASE_HOST" ]
}

@test "$name: uses DATABASE_PORT for db config" {
  template_with_defaults $name

  [ "$status" -eq 0 ]
  local credentials=$(get '.data["credentials.py"] | @base64d')
  local database_port=$(grep PORT <<< "${credentials}" | sed -e 's,.*environ\['"'"'\(.*\)'"'"'].*,\1,' | tee /dev/stderr)
  echo "$database_port" | tee /dev/stderr
  [ "$database_port" = "DATABASE_PORT" ]
}

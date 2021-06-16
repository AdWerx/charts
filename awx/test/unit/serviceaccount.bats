#!/usr/bin/env bats

load _helpers

name="serviceaccount"

@test "$name: is not rendered when serviceAccountName is provided" {
  template $name --set serviceAccountName=myServiceAccount

  [ "$status" -eq 1 ]
}


@test "$name: name is awx" {
  template $name

  local actual=$(get '.metadata.name')
  [ "$actual" = "awx" ]
}

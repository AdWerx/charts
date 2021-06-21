#!/usr/bin/env bats

load ../_helpers

name="serviceaccount"

@test "$name: is not rendered when serviceAccountName is provided" {
  template_with_defaults $name --set serviceAccountName=myServiceAccount

  [ "$status" -eq 1 ]
}


@test "$name: name is awx" {
  template_with_defaults $name

  local actual=$(get '.metadata.name')
  [ "$actual" = "awx" ]
}

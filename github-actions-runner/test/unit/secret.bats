#!/usr/bin/env bats

load _helpers

name="secret"

@test "$name: data includes the registration token" {
  template $name --set runner.registrationToken=abcde123

  local encoded=$(get '.data.registration_token')
  assert_equal "${encoded}" "$(printf abcde123 | base64)"
}

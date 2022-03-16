#!/usr/bin/env bats

load ../_helpers

name="settings-configmap"

@test "$name: replicas is one"  {
  template_with_defaults $name -f $(valuesPath extra-configuration)
  assert_success

  run yq -r '.data["settings.py"]' <<< "$output"
  assert_success
  assert_line --regexp '^SOCIAL_AUTH_SAML_SP_ENTITY_ID ='
  assert_line --regexp '^OTHER_VAR ='
}

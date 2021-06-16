#!/usr/bin/env bats

load ../_helpers

@test "dry run: successful" {
  run helm install -f $(valuesPath test-defaults) --dry-run --debug awx "$(chart_dir)"
  echo -e "$output" | tee /dev/stderr

  [ "$status" -eq 0 ]
}

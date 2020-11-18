load '../../../test/bats-support/load'
load '../../../test/bats-assert/load'

helm_cmd="${HELM_COMMAND:-helm}"

# chart_dir returns the directory for the chart
chart_dir() {
  echo ${BATS_TEST_DIRNAME}/../..
}

valuesPath() {
  echo "${BATS_TEST_DIRNAME}/values/$1.yaml"
}

template() {
  cd `chart_dir`

  local file="$1"
  shift

  run_debug ${helm_cmd} template --show-only "templates/$file.yaml" "$@" `chart_dir`

  assert_success
}

run_debug() {
  run "$@"
  if ! [ -z "$DEBUG" ]; then
    echo -e "[DEBUG] \n\n $output"
  fi
}

get() {
  got=$(echo "$output" | yq -r $@)
  if ! [ -z "$DEBUG" ]; then
    $(echo "[DEBUG] GET: $@ -> $got" >> /dev/stderr)
  fi
  echo "$got"
}

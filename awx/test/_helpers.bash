load '../../../test/bats-support/load'
load '../../../test/bats-assert/load'

# chart_dir returns the directory for the chart
chart_dir() {
  echo "${BATS_TEST_DIRNAME}/../.."
}

valuesPath() {
  echo "$(chart_dir)/test/values/$1.yaml"
}

template() {
  cd "$(chart_dir)" || exit

  local file="$1"
  shift

  run helm template -s "templates/$file.yaml" "$(chart_dir)" "$@"
}

template_with_defaults() {
  template "$@" -f "$(valuesPath test-defaults)"
}

run_debug() {
  run "$@"
  echo -e "$output" > /dev/stderr
}

get() {
  echo "$output" | yq -r "$@" | tee /dev/stderr
}

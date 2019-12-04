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

  run_debug helm template -x "templates/$file.yaml" "$@" .
}

run_debug() {
  run "$@"
  echo -e "$output" | tee /dev/stderr
}

get() {
  echo "$output" | yq -r $@ | tee /dev/stderr
}

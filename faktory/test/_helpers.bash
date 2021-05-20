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

  run_debug helm template -s "templates/$file.yaml" "$(chart_dir)" "$@"
}

run_debug() {
  run "$@"
  echo -e "$output"
}

get() {
  got=$(echo "$output" | yq -r $@)
  $(echo "GET: $@ -> $got" >> /dev/stderr)
  echo "$got"
}

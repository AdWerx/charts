#!/usr/bin/env bats

load "../_helpers"

@test "deploys faktory" {
  release=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z' | fold -w 4 | head -n 1)
  namespace=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z' | fold -w 4 | head -n 1)
  kubectl config use-context docker-for-desktop
  kubectl config set-context --current --namespace="$namespace"
  cd `chart_dir`

  kubectl create namespace "$namespace" | tee /dev/stderr
  run_debug helm install \
    --namespace "$namespace" \
    --set "password=password" \
    --name "$release" \
    .

  pod_name="$release-faktory-0"
  kubectl -n "$namespace" \
    wait \
    --for condition=Ready \
    --timeout=60s \
    pod/"$pod_name" | tee /dev/stderr
  kubectl logs "$pod_name" -c server | tee /dev/stderr
  kubectl logs "$pod_name" -c config-watcher | tee /dev/stderr

  helm delete --purge "$release" | tee /dev/stderr
  kubectl delete namespace "$namespace" | tee /dev/stderr
  # redis fails to start because the socket file it's trying to bind
  # has a name that's too long. https://github.com/moby/moby/issues/23545
  [ 1 = 0 ]
}

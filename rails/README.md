## Why Helm?

https://medium.com/ingeniouslysimple/deploying-kubernetes-applications-with-helm-81c9c931f9d3

## Why a helm umbrella chart?

The current best practice for composing a complex application from discrete parts is to create a top-level umbrella chart that exposes the global configurations, and then use the charts/ subdirectory to embed each of the components.

https://akomljen.com/package-kubernetes-applications-with-helm/

## What's this look like in practice? (setup)

New stack from scratch example:

```
› helm install . --set global.image.tag=c516f8f2e9b4d339d1192ea68a96f8c7a46afce1


```

## How do I make changes?

In-place

## What are the future plans?

CI w/ Spinnaker
https://cloud.google.com/solutions/continuous-delivery-spinnaker-kubernetes-engine




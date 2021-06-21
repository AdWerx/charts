# charts

Helm charts created by [Adwerx Engineering](https://engineering.adwerx.com)

## Installing charts from this repo

You can find our public charts in [Helm Hub](https://hub.helm.sh/charts/adwerx)

_Or_

You'll first need to add the `adwerx` repository with the command below:

```bash
helm repo add adwerx https://adwerx.github.io/charts/
```

You can now install charts like so:

```bash
helm install adwerx/awx --version 1.0.0
```

## Contributing

Please review the CODE_OF_CONDUCT and REVIEW_GUIDELINES before contributing.

### Code of Conduct

Please review our [Code of Conduct](./CODE_OF_CONDUCT.md) before contributing.

When opening or reviewing a pull request, please keep in mind the [chart review guidlelines](./REVIEW_GUIDELINES.md).

### Versioning charts

Charts are versioned using the SEMVER pattern. Please bump the chart version and re-package the chart when changes are made. If you're unsure how to do this please open an issue.

### Publishing a chart

Our chart files are served from GitHub Pages. The `docs/` folder is served, so the `index.yaml` and all chart files (.tgz) must reside in `docs/`.

To package a chart and update the `index.yaml`, you can use the `bin/package` script:

First, ensure you've commited your changes to the chart and the chart is ready to publish. Then, bump the version in the `Chart.yaml` to the version you'd like to publish. Then use the `bin/package` script to run tests, package the chart, commit the package and version bump, and tag that commit with the chart and version.

```bash
bin/package {name}
```

The last thing to do is to `git push origin master --tags` and after the github pages build, the chart will be available from our repository at https://adwerx.github.io/charts/index.yaml

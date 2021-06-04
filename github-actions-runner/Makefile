repo=adwerx/github-actions-runner

image:
	@if [ -z "${TAG}" ]; then echo 'please provide image tag via TAG=' && exit 1; fi
	docker build . -t ${repo}:${TAG}

tag: image
	docker tag ${repo}:${TAG} ${repo}:latest

push: tag
	docker push ${repo}:${TAG}

.PHONY: image tag push

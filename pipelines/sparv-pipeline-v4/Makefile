.DEFAULT_GOAL=build

include .env

build:
	docker build \
		--tag rogermahler/sparv_v4:latest \
		--tag rogermahler/sparv_v4:${SPARV_DOCKER_VERSION} \
		--tag sparv_v4:latest \
		--tag sparv_v4:${SPARV_DOCKER_VERSION} \
		--build-arg	BUILD_SPARV_MODELS=${BUILD_SPARV_MODELS} \
		--file Dockerfile .

publish:
	docker login docker.io
	docker push rogermahler/sparv_v4:latest

bash:
	-docker run --entrypoint /bin/bash --rm -it -t sparv_v4:latest

bash2:
	-docker run --entrypoint /bin/bash \
		--user `id -u`:`id -g` \
		--workdir=/work \
		--mount "type=bind,src=`pwd`,dst=/work" \
		--volume="/etc/passwd:/etc/passwd:ro" \
		--volume="/etc/group:/etc/group:ro" \
		--volume="/etc/shadow:/etc/shadow:ro" \
        --volume="/data/sparv/models:/sparv/models:rw" \
		--rm -it sparv_v4:latest

prune:
	-docker container prune -f

killall:
	-docker rm `docker ps -aq`

rmi_untagged:
	-docker rmi `docker images | grep "^<none>" | awk "{print $3}"`

.PHONY: build bash bash2 prune killall rmi_untagged publish

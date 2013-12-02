
all: help

help:
	@echo 'To build a Docker image, run "make image VERSION=1.2.x"'

check-version:
ifndef VERSION
	@echo "Error: VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

image: check-version
	sed -r -e "s/VERSION/$(VERSION)/g" install/Dockerfile.template > install/Dockerfile
	docker build -t cassandra:$(VERSION) install/
	rm -f install/Dockerfile


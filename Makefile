ifdef VERSION
	project_version:=$(VERSION)
else
	project_version:=$(shell git rev-parse --short=8 HEAD)
endif

ifdef PROJECT_NAME
	project_name:=$(PROJECT_NAME)
else
	project_name:=$(shell basename $(CURDIR))
endif

ifdef SRC_DIR
	source_directory:=$(SRC_DIR)
else
	source_directory:=$(CURDIR)/image
endif

repository:=gcr.io/applegate-road-2829/$(project_name)
latest_image:=$(repository):latest
version_image:=$(repository):$(project_version)
docker_machine_ip:=$(shell bash $(CURDIR)/image/docker-ip.sh)

version:
	@echo [INFO] [version]
	@echo [INFO]    Build Makefile Version 1.46
	@echo

settings: version
	@echo [INFO] [settings]
	@echo [INFO]    project_version=$(project_version)
	@echo [INFO]    project_name=$(project_name)
	@echo [INFO]    repository=$(repository)
	@echo [INFO]    latest_image=$(latest_image)
	@echo [INFO]    version_image=$(version_image)
	@echo [INFO]    source_directory=$(source_directory)
	@echo [INFO]    cluster_name=$(cluster_name)
	@echo [INFO]    docker_machine_ip=$(docker_machine_ip)
	@echo

help: settings
	@printf "\e[1;34m[INFO] [information]\e[00m\n\n"
	@echo [INFO] This make process supports the following targets:
	@echo [INFO]    clean       - clean up and targets in project
	@echo [INFO]    production  - run the service locally in production mode
	@echo [INFO]    desktop     - run the service locally in desktop/development mode
	@echo
	@echo [INFO] The script supports the following parameters:
	@echo [INFO]    VERSION      - version to tag docker image wth, default value is the git hash
	@echo [INFO]    PROJECT_NAME - project name, default is git project name
	@echo [INFO]    SRC_DIR      - source code, default is "image"
	@echo [INFO]    CLUSTER_NAME - cluster name, default is "project_name-cluster-1"
	@echo
	@echo [INFO] This tool expects the project to be located in a directory called image.
	@echo [INFO] If there is a Makefile in the image directory, then this tool will execute it
	@echo [INFO] with either clean and build targets.
	@echo
	@echo [INFO] Run as service with ports in interactive mode:
	@echo [INFO]
	@echo [INFO]     make desktop
	@echo [INFO]     make production


clean: settings
	export DOCKER_IP=$(docker_machine_ip);cd $(CURDIR)/env/production;docker-compose rm
	export DOCKER_IP=$(docker_machine_ip);cd $(CURDIR)/env/desktop;docker-compose rm

production: settings
	export DOCKER_IP=$(docker_machine_ip);cd $(CURDIR)/image;./launch-services.sh production

desktop: settings
	export DOCKER_IP=$(docker_machine_ip);cd $(CURDIR)/image;./launch-services.sh desktop

stop: settings
	export DOCKER_IP=$(docker_machine_ip);cd $(CURDIR)/image;./stop-services.sh desktop
	export DOCKER_IP=$(docker_machine_ip);cd $(CURDIR)/image;./stop-services.sh production
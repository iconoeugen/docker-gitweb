# iconoeugen/docker-gitweb

A docker image to run GitWeb

> GitWeb website: [git-scm.com](https://git-scm.com/docs/gitweb)

## Overview

This docker image will start a Gitweb server with only one Git repository.

## Quick start

### Clone this project:

``` bash
git clone https://github.com/iconoeugen/docker-gitweb
cd docker-gitweb
```

### Make your own GitWeb image

Build your own image:

``` bash
docker build -t gitweb_gitweb .
```

Run your built image:

``` bash
docker run --name gitweb_test -p 8080:8080 --detach gitweb_gitweb
```

Check running container:

``` bash
git ls-remote http://localhost:8080/git/dummy.git
```

Stop running container:

``` bash
docker stop gitweb_test
```

Remove stopped cotainer:

``` bash
docker rm gitweb_test
```

### Make Git repository persitent

The repository is store within the container under the path `/var/lib/git`. To make the repository persitent, just mount
a directory into the container:

``` bash
docker run --name gitweb_test -p 8080:8080 -v /tmp/gitweb:/var/lib/git --detach gitweb_gitweb
```

Make sure that the user `uid=48(apache)` (or whatever user you use when starting the container with option `-u`) has
write permissions to the directory on the host.

## Docker compose

Compose is a tool for defining and running multi-container Docker applications, using a Compose file  to configure
the application services.

Build docker images:

``` bash
docker-compose build
```

Create and start docker containers with compose:

``` bash
docker-compose up -d
```

Stop docker containers

``` bash
docker-compose stop
```

Removed stopped containers:

``` bash
docker-compose rm
```

## Environment Variables

- **GIT_PROJECT_NAME**: Git project repository name. The repository will be available at
`http://localhost:8080/git/<GIT_PROJECT_NAME>.git`. Defaults to `dummy`.
- **GIT_DESCRIPTION**: Short single line description of the project. Defaults to `Dummy repository`.
- **GIT_CATEGORY**: Singe line category of a project, used to group projects. Defaults to empty string.
- **GIT_OWNER**: Set repository’s owner that is displayed in the project list and summary page. Defaults to `Owner`.

### Set your own environment variables

Environment variables can be set by adding the --env argument in the command line, for example:

``` bash
docker run --env GIT_PROJECT_NAME="super" --name gitweb_test -p 8080:8080 --detach gitweb_gitweb
```

To clone the `super` repository from the container started before, use the command:

``` bash
git clone http://localhost:8080/git/super.git
```

## OpenShift

OpenShift Origin is a distribution of Kubernetes optimized for continuous application development and multi-tenant deployment.

More information:
- https://www.openshift.org/
- https://github.com/openshift/origin

The OpenShift *GitWeb application template* is available in *openshift*

### Upload template to OpenShift

Create a new template application in OpenShift (before continue, make sure you are logged in and a new project is created in OpenShift)

``` bash
oc create -f openshift/gitweb.json
```

### Create GitWeb application from template

``` bash
oc new-app gitweb -p GIT_PROJECT_NAME=super
```

## Tests

Access the GitWeb UI at: http://localhost:8080/git

Push content to the new empty repository:

``` bash
mkdir dummy
cd dummy
git init
touch README
git add README
git commit -m "First commit"
git remote add test http://localhost:8080/git/dummy.git
git push test master
```

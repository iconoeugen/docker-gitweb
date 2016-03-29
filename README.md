# iconoeugen/docker-gitweb

A docker image to run GitWeb

> GitWeb website: [git-scm.com](https://git-scm.com/docs/gitweb)

## Quick start

### Clone this project:

``` bash
git clone https://github.com/iconoeugen/docker-gitweb
cd docker-gitweb
```

### Make your own GitWeb image

Build your image:

``` bash
docker build -t gitweb_gitweb .
```

Run your image:

``` bash
docker run --name gitweb_test -p 8080:80 --detach gitweb_gitweb
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
docker run --env GIT_PROJECT_NAME="super" --name gitweb_test -p 8080:80 --detach gitweb_gitweb
```

To clone the `super` repository from the container started before, use the command:

``` bash
git clone http://localhost:8080/git/super.git
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

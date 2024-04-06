# Build a REST API with Django, Docker and Postgres SQL

## How use Docker?

* Define Dockerfile
* Create Docker Compose configuration
* Run all commands via Docker Compose

## Using docker compose

```bash
docker-compose run --rm app sh -c "python manage.py collectstatic"
```

Where:

* `docker-compose` runs a Docker Compose command
* `run` will start a specific container defined in config
* `--rm` removes the container
* `app` removes the container
* `sh -c` passes in a shell command
* Command to run inside container

> To create a docker image, use `docker build .` in the bash
> To run docker-compose.yml, use `docker-compose build` in the bash
> To run the configurations of flake8 run `docker-compose run --rm app sh -c "flake8"` in the bash

To build, create, starts the container to services run in bash:

```bash
docker-compose up
```

## Creating a Django project

To create a django project with the configuration of docker:

```bash
docker-compose run --rm app sh -c "django-admin startproject app ."
```

The dot (.) is for the app is there created in the current directory.

## Configuring GitHub Actions

* Create a config file at `.github/workflows/checks.yml`
  * Set trigget
  * Add steps for running testing and linting
* Configure Docker Hub auth
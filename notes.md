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
* `app` name of container
* `sh -c` passes in a shell command
* Command to run inside container

> To create a docker image, use `docker build .` in the bash
> To run docker-compose.yml, use `docker-compose build` in the bash
> To run the configurations of flake8 run `docker-compose run --rm app sh -c "flake8"` in the bash

To starts the container to services run in bash:

```bash
docker-compose up
```

To build or rebuild the container pass:

```bash
docker-compose build
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

## Unit test in Django

* Based on the `unittest` library
* Django add features
  * Test client - dummy web browser
  * Simulate authentication
  * Temporary database
* Django REST Framework adds features
  * API test client

Where do you put tests?

* Placeholder `tests.py` added to each app
* Or, create `tests/` subdirectory to splits test up
* Keep in mind:
  * Only use `tests.py` or `tests/` directory (not both)
  * Test modules must start with `test_`
  * Test directories must contain `__init__.py`

Test Database:

* Test code that uses the DB
* Specific database for tests
* Happening for every test

Test classes:

* `SimpleTestCase`
  * No database integration
  * Useful if no database is required for you test
  * Save time executing tests
* `TestCase`
  * Database integration
  * Useful for testing code that uses the database

Writting tests:

* Import test class
  * `SimpleCaseTest` - No database
  * `TestCase` - Database
* Import objects to test
* Define test class
* Add test method
* Setup inputs
* Execute code to be tested
* Check output

To run tests:

```bash
python manage.py test
```

## Mocking

* Override or change behaviour of dependencies of tests
* Avoid unintented side effects
* Isolate code being tests

Benefits:

* Avoid relying on external services
  * Can't guarantee they will be available
  * Makes test unpredictable and inconsistent
* Avoid unintented consequences
  * Accidentally sending emails
  * Overloading extenal services

How use mock code?

* Use `unittest.mock`
  * `MagicMock/Mock` - Replace real objects
  * `patch` - Overrides code for tests

## Testing web requests

* Based on Django's TestClient
* Make requests
* Check result
* Override authentication

### Using

* Import `API Client`
* Create Client
* Make Request
* Check result (we can pass a list of expected results)

```python
from django.test import SimpleTestCase
from rest_framework.test import APIClient

class TestViews(SimpleTestCase):

  def test_get_grettings(self):
    """ Test getting greetings"""
    client = APIClient()
    rest = client.get('/grettings/')

    self.assertEqual(res.status.code, 200)
    self.assertEqueal(
      res.data,
      ["Hello!", "Bonjour!", "Hola!"]
    )
```

## Configure PostgreSQL database

We define the database in docker-compose

```yaml
services:
  app:
    depends_on:
      - db
  db:
    image: postgres:13-alpine
    volumes:
      - dev-db-data:/var/lib/postgresql/data

volumes:
  dev-db-data:
  dev-static-data:
```

* Set `depends_on` on `app` serivce to start `db` first
* Docker Compose creates a network
* The `app` service can use `db` hostname

Volumes:

* Persistent data
* Maps directory in container to local machine

## Database configurtion in Django

* Configure Django
  * Tell Django how to connect
* Install database adaptor dependencies
  * Install the tool Django uses to connect
* Update python requirements

Django needs to know:

* Engine (type of database)
* Hostname (IP or domain name for database)
* Port
* Database name
* Username
* Password

```python
# settings.py

DATABASES = {
  'default': {
      'ENGINE':'django.db.backends.postgresql',
      'HOST':os.environ.get('DB_HOST'),
      'NAME':os.environ.get('DB_NAME'),
      'USER':os.environ.get('DB_USER'),
      'PASSWORD':os.environ.get('DB_PASS'),
    }
  }
```

`Psycopg2` the package that we need in order for Django to connect to our database.

* Most popular PostgreSQL adaptor for Python
* Supported by Django

Installation options:

* `psycopg2-binary`
  * Ok for develpment
  * Not good for production
* `psycopg2` ✔️
  * Compiles from source
  * Required additional dependencies
  * Easy to install with docker

Installing `Psycopg2`

* List of package dependencies in docs:
  * C compiler
  * python3-dev
  * libpq-dev
* Equivalent packages for Alpine
  * postgresql-client
  * build-base
  * postgresql-dev
  * musl-dev
* Found by searching and trial and error
* Docker best practice
  * Clean up build dependencies

## Problems with Docker compose

* Using `depends_on` ensure service starts
  * Doesn't ensure application is running

Solution:

* **Make Django "wait for db"**
  * Check for database availability
  * Continue when database ready
* Create custom Django management command

## Create an app in Django with Docker Compose

```bash
docker-compose run --rm app sh -c "python manage.py startapp core"
```

We need to ensure that the new app `core` is in `INSTALLED_APPS` in `settings.py`

## Creating Migrations for database

```bash
pyhton manage.py makemigrations

python manage.py migrate
```

If after create models for database in Django


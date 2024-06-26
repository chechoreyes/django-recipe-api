FROM python:3.13-rc-alpine
LABEL maintainer="chechoreyes.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # Install postgresql package
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
    build-base postgresql-dev gcc python3-dev libpq-dev && \
    # build-base postgresql-dev gcc python3-dev musl-dev && \
    # /py/bin/pip install --no-cache-dir psycopg2 && \
    # /py/bin/pip install --no-cache-dir "psycopg[binary]" && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ;\
    fi && \
    # Remove tmp folder
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Enviorment variable 
ENV PATH="/py/bin:$PATH"

# Switches to user to user in django
USER django-user
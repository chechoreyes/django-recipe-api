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
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ;\
    fi && \
    # Remove tmp folder
    rm -rf /tmp && \ 
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Enviorment variable 
ENV PATH="/py/bin:$PATH"

# Switches to user to user in django
USER django-user
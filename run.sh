#!/bin/bash

source $VENV/bin/activate
env > /tmp/env
CONF=conf/production.env,/tmp/env

if [[ $MIGRATE_DB == true || $MIGRATE_DB == TRUE ]]; then
    echo "migrate db"
    foreman run -e $CONF python manage.py syncdb --noinput
    foreman run -e $CONF python manage.py migrate cabotapp --noinput
    foreman run -e $CONF python manage.py migrate djcelery --noinput
fi

foreman start -f Procfile -e $CONF

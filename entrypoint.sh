#!/bin/bash

echo "###########################"
echo "Ramping up Symfony app....."
echo "###########################"

echo "Waiting for mysql on $DATABASE_HOST..." \
  && while ! nc -z $DATABASE_HOST 3306; do sleep 0.3; done \
  && echo "Mysql is ready! Launching Symfony..." \
  && composer run-script post-update-cmd \
  && echo "Migrating database, if needed"
  && bin/console doctrine:schema:update -e prod --force \
  && php bin/console server:run -vvv 0.0.0.0 -e prod

#!/bin/sh

echo "Setup a database ..."
echo "If this appears hung, then Postgres has an open connection. Shut down the Django test server."
# This is required to fix LATIN1 as the default LANG on the preceise64 box on Vagrant
pg_dropcluster --stop 9.1 main ; pg_createcluster --start --locale en_US.UTF-8 9.1 main
cat << EOF | su - postgres -c psql
-- Create the user:
CREATE USER toolchest PASSWORD 'toolchest' CREATEDB;

-- Create the database:
CREATE DATABASE toolchest WITH owner = toolchest ENCODING = 'utf-8';

-- Grant privileges to the user
GRANT ALL PRIVILEGES ON DATABASE toolchest TO toolchest;
EOF

echo "Setup Django app database & running update command  ..."
cd /vagrant/toolchest
python manage.py syncdb --noinput --settings=toolchest.settings.development
python manage.py update --settings=toolchest.settings.development

echo "CommandError: Compressor is disabled... THIS IS NORMAL and EXPECTED."


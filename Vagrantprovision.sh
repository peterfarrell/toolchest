#!/bin/sh

echo "Set sensible OS env defaults ..."
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

echo "Running apt-get update ..."
apt-get update

echo "Install OS dependencies ..."
apt-get install -y python-dev postgresql libpq-dev libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev git

echo "Install PIP ..."
cd /home/vagrant
if [ ! -f get-pip.py ]
then
    wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
    python get-pip.py
fi

echo "Install Requirements via PIP ..."
pip install -r /vagrant/requirements/development-requirements.txt

echo "Set the default settings module in the user profile ..."
cd /home/vagrant
echo "export DJANGO_SETTINGS_MODULE=toolchest.settings.development" >> .profile
source .profile

echo "Run database setup script ..."
cd /vagrant
sudo bash ./Vagrantprovision_database.sh

echo "SUCCESS!"
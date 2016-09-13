FROM centos:7

ENV VENV=/home/cabot/venv CABOT_PATH=/opt/cabot

RUN yum install -y git epel-release gcc gcc-c++ make python-devel python-virtualenv postgresql-devel libxml2-devel libxslt-devel cyrus-sasl-devel openldap-devel rubygems; \
    yum install -y python-pip python-versiontools nodejs npm nginx; \
    pip install -U pip; \
    npm install -g coffee-script less@1.3; \
    gem install foreman --version 0.77.0; \
    echo 'requirepass cabot' >> /etc/redis.conf; \
    useradd cabot; \
    mkdir /opt/cabot; \
    chown cabot $CABOT_PATH; \
    su cabot -c 'git clone https://github.com/arachnys/cabot.git $CABOT_PATH'; \
    su cabot -c 'virtualenv --setuptools $VENV'

COPY production.env $CABOT_PATH/conf/production.env

WORKDIR $CABOT_PATH

RUN su cabot -c 'source {venv}/bin/activate; pip install versiontools; \
                 foreman run -e conf/production.env $VENV/bin/pip install --editable $CABOT_PATH --exists-action=w; \
                 foreman run -e conf/production.env python manage.py collectstatic --noinput; \
                 foreman run -e conf/production.env python manage.py compress'

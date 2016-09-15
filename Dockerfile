FROM centos:7

ENV VENV=/home/cabot/venv CABOT_PATH=/opt/cabot

RUN yum install -y git epel-release gcc gcc-c++ make python-devel python-virtualenv postgresql-devel libxml2-devel libxslt-devel cyrus-sasl-devel openldap-devel rubygems; \
    yum install -y python-pip python-versiontools nodejs npm nginx redis; \
    pip install -U pip; \
    npm install -g coffee-script less@1.3; \
    gem install foreman --version 0.77.0; \
    echo 'requirepass cabot' >> /etc/redis.conf; \
    useradd cabot; \
    mkdir /opt/cabot; \
    chown cabot $CABOT_PATH; \

COPY production.env $CABOT_PATH/conf/production.env
COPY run.sh nginx.conf /tmp/

USER cabot
WORKDIR $CABOT_PATH
EXPOSE 8080

RUN git clone https://github.com/arachnys/cabot.git $CABOT_PATH; \
    virtualenv --setuptools $VENV; \
    source $VENV/bin/activate; pip install versiontools; \
    foreman run -e conf/production.env $VENV/bin/pip install --editable $CABOT_PATH --exists-action=w; \
    foreman run -e conf/production.env python manage.py collectstatic --noinput; \
    foreman run -e conf/production.env python manage.py compress; \
    cat /etc/redis.conf | sed 's|^dir.*$|dir /var/tmp|' | sed '/^logfile/d' > /tmp/redis.conf; \
    echo 'redis:     redis-server /tmp/redis.conf' >> $CABOT_PATH/Procfile; \
    echo 'nginx:     nginx -c /tmp/nginx.conf' >> $CABOT_PATH/Procfile;

CMD ["sh", "/tmp/run.sh"]

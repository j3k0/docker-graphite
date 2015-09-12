# Graphite stack

# Based on https://github.com/jmreicha/graphite-docker
FROM ennexa/base

# This suppresses a bunch of annoying warnings from debconf
ENV DEBIAN_FRONTEND noninteractive

# Install system dependencies
RUN \
  wget -qO - https://deb.nodesource.com/setup_0.12 | bash - && \
  apt-get -qq update -y && \
  apt-get -qq install -y build-essential \
    # Graphite dependencies
    python-dev libcairo2-dev libffi-dev python-pip \
    # Supervisor
    supervisor \
    # nginx + uWSGI
    nginx uwsgi-plugin-python \
    # StatsD
    nodejs && \
  apt-get -qq clean -y && rm -rf /var/lib/apt/lists/*
	

# Install StatsD
RUN \
  mkdir -p /opt && \
  cd /opt && \
  wget -qO statsd.tar.gz https://github.com/etsy/statsd/archive/v0.7.2.tar.gz && \
  tar -xzf statsd.tar.gz && \
  mv statsd-0.7.2 statsd

# Install Python packages for Graphite
RUN pip install graphite-api[sentry] whisper carbon

# Optional install graphite-api caching
# http://graphite-api.readthedocs.org/en/latest/installation.html#extra-dependencies
# RUN pip install -y graphite-api[cache]

# Graphite
COPY conf/graphite/carbon.conf conf/graphite/storage-schemas.conf conf/graphite/storage-aggregation.conf /opt/graphite/conf/
# Supervisord
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# StatsD
COPY conf/statsd/statsd_config.js /etc/statsd/config.js
# Graphite API
COPY conf/graphite/graphite-api.yaml /etc/graphite-api.yaml
# uwsgi
COPY conf/uwsgi.conf /etc/uwsgi.conf
# nginx
COPY conf/nginx/* /etc/nginx/

# nginx
EXPOSE 80 \
# graphite-api
8080 \
# Carbon line receiver
2003 \
# Carbon pickle receiver
2004 \
# Carbon cache query
7002 \
# StatsD UDP
8125 \
# StatsD Admin
8126

VOLUME ["/etc/nginx", "/etc/statsd", "/opt/graphite/conf"]

# Launch stack
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# Graphite stack

# Build from Ubuntu base
FROM ennexa/base

# This suppresses a bunch of annoying warnings from debconf
ENV DEBIAN_FRONTEND noninteractive

# Install system dependencies
RUN \
  apt-get update -y && \
  apt-get install -y --no-install-recommends \
    build-essential \
    # Graphite dependencies
    python-dev libcairo2-dev libffi-dev python-pip \
    # Supervisor
    supervisor \
    # nginx + uWSGI
    nginx uwsgi-plugin-python && \
  apt-get autoremove -y && apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*
  
  # apt-get remove -y build-essential && \
  #      apt-get autoremove -y && apt-get clean

# Install Python packages for Graphite
RUN pip install graphite-api[sentry] whisper carbon

# Optional install graphite-api caching
# http://graphite-api.readthedocs.org/en/latest/installation.html#extra-dependencies
# RUN pip install -y graphite-api[cache]

# Graphite
COPY conf/graphite/carbon.conf conf/graphite/storage-schemas.conf conf/graphite/storage-aggregation.conf /opt/graphite/conf/
# Supervisord
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Graphite API
COPY conf/graphite/graphite-api.yaml /etc/graphite-api.yaml
# uwsgi
COPY conf/uwsgi.conf /etc/uwsgi.conf
# nginx
COPY conf/nginx/ /etc/nginx/

# nginx
EXPOSE 80 \
# graphite-api
8080 \
# Carbon line receiver
2003 \
# Carbon pickle receiver
2004 \
# Carbon cache query
7002

VOLUME ["/etc/nginx", "/opt/graphite/conf"]

# Launch stack
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# StatsD

FROM debian:bookworm

# This suppresses a bunch of annoying warnings from debconf
ENV DEBIAN_FRONTEND noninteractive
ENV NODE_MAJOR 20

# Prepare useful tools
RUN \
  apt-get update && \
  apt-get install -y \
	  ca-certificates \
	  curl \
	  gnupg \
	  net-tools \
	  procps \
	  unzip \
	  vim \
	  wget \
  && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && apt-get install nodejs -y && \
  apt-get -qq clean -y && rm -rf /var/lib/apt/lists/*

# Install system dependencies
# RUN \
#   wget -qO - https://deb.nodesource.com/setup_4.x | bash - && \
#   apt-get -qq update -y && \
#   apt-get -qq install -y nodejs unzip && \
#   apt-get -qq clean -y && rm -rf /var/lib/apt/lists/*

# Install StatsD
RUN \
  mkdir -p /opt && \
  cd /opt && \
  wget -qO statsd.zip https://github.com/etsy/statsd/archive/master.zip && \
  unzip statsd.zip && \
  mv statsd-master statsd && \
  rm -f statsd.zip

# StatsD
COPY conf/config.js /etc/statsd/config.js

EXPOSE \
  # StatsD UDP
  8125/udp \
  # StatsD Admin
  8126

VOLUME ["/etc/statsd"]

# Launch StatsD
CMD ["/usr/bin/node", "/opt/statsd/stats.js", "/etc/statsd/config.js"]

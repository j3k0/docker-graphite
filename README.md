# Graphite / StatsD / Grafana with Docker

This project contains 2 docker images

- [Graphite] (https://github.com/Ennexa/docker-graphite/tree/master/graphite)
- [StatsD] (https://github.com/Ennexa/docker-graphite/tree/master/statsd)

## Setup

##### Start Graphite

    mkdir -p /data/graphite
    docker run -ti -d --name graphite -v /data/graphite:/opt/graphite/storage/whisper -p 8000:8000 ennexa/graphite

##### Start StatsD
    docker run -ti -d --name statsd -P --link graphite:graphite ennexa/statsd

##### Start Grafana

    docker run -ti -d --name grafana -p 3000:3000 --link graphite:graphite grafana/grafana


Go to `http://yourhostname:3000` and login with username/password `admin`/`admin`

Exposing the port `8000` might make the graphite end point accessible to public. If you are planning to access graphite only from
the grafana container, you can skip publishing the port. Instead, when creating the data source in Grafana admin page
use `http://graphite:8000` as the data source url and select `proxy` as the `access` method.

### Using docker-compose

See the `docker-compose.yml` file for an example configuration for use with `docker-compose`

    sudo pip install -U docker-compose
    git clone https://github.com/ennexa/docker-graphite
    cd docker-graphite
    docker-compose up -d

##### Grafana

* Interface: `http://yourhostname:3000`
* Login: `admin`/`admin`

**Notes**

In a production environment it would be a good idea to mount in a separate
volume for data in to the /data as a mount point so that if the OS runs out of
space the volume can be attached somewhere else.

You may need to run the script with sudo if the /data volume has restricted
permissions.

#### Credits

These images are based on the docker-graphite image by Josh Reichardt
https://github.com/jmreicha/graphite-docker
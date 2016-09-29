# docker-graphite
Graphite web + carbon + whisper in a Docker container

**WORK IN PROGRESS**
The existing images for Graphite all seemed to be either bloated, out-of-date, or built for use with certain extensions. This Docker image is an attempt to create a basic image that makes it very easy to get Graphite up-and-running quickly.

### Quick start:
```shell
docker run \
  -p 8000:8000 \
  -v /local/storage:/opt/graphite/storage \
  -e GRAPHITE_WEB_SECRET_KEY='<secret key>' \
  praekeltfoundation/graphite
```
This will expose the Graphite web frontend and API at port `8000` on the host with the persistent storage mounted at `/local/storage`. Be sure to set the secret key to something better.

#### Volumes and ports
* `/opt/graphite/storage` volume for persistent storage
* Port `8000` for the graphite-web interface

#### Processes
Two processes are managed by supervisord:
* gunicorn running graphite-web
* carbon-cache

#### Configuration
The example configurations are used in the following places:
* `conf/graphite.wsgi.example` -> `webapp/graphite/wsgi.py`

#### Storage schemas
The retention schema that is used is 1 minute for 1 day, 5 minutes for 1 year,
and 1 hour for 5 years.

#### AMQP Configuration

Carbon can collect metrics via AMQP and can be configured to do using the following environment variables.

* **ENABLE_AMQP** defaults to `False`
* **AMQP_VERBOSE** defaults to `False`
* **AMQP_HOST** defaults to `localhost`
* **AMQP_PORT** defaults to `5672`
* **AMQP_VHOST** defaults to `/`
* **AMQP_USER** defaults to `guest`
* **AMQP_PASSWORD** defaults to `guest`
* **AMQP_EXCHANGE** defaults to `graphite`
* **AMQP_METRIC_NAME_IN_BODY** defaults to `False`

We added a simple `local_settings.py` based on the `webapp/graphite/local_settings.py.example` example. The `SECRET_KEY` and email settings can be set using environment variables.

#### Extra functionality
There are a number of extra dependencies that can be installed to enable extra functionality in Graphite. We install only `txAMQP` for AMQP functionality. See [here](http://graphite.readthedocs.org/en/0.9.15/install.html#dependencies) for more information.

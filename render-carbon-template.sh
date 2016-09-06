#!/bin/sh

render_template() {
    eval "echo \"$(cat $1)\""
}

ENABLE_AMQP=${ENABLE_AMQP:-False}
AMQP_VERBOSE=${AMQP_VERBOSE:-False}

AMQP_HOST=${AMQP_HOST:-localhost}
AMQP_PORT=${AMQP_PORT:-5672}
AMQP_VHOST=${AMQP_VHOST:-/}
AMQP_USER=${AMQP_USER:-guest}
AMQP_PASSWORD=${AMQP_PASSWORD:-guest}
AMQP_EXCHANGE=${AMQP_EXCHANGE:-graphite}
AMQP_METRIC_NAME_IN_BODY=${AMQP_METRIC_NAME_IN_BODY:-False}

render_template carbon.conf.example > carbon.conf

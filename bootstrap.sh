#!/usr/bin/env bash
set -e

python $GRAPHITE_ROOT/webapp/graphite/manage.py syncdb --noinput

exec supervisord -c /etc/supervisor/supervisord.conf

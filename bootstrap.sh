#!/usr/bin/env bash
set -e

# These dirs need to exist, but graphite doesn't create them.
mkdir -p $GRAPHITE_ROOT/storage/log/webapp
mkdir -p $GRAPHITE_ROOT/storage/whisper

python $GRAPHITE_ROOT/webapp/graphite/manage.py syncdb --noinput

exec supervisord -c /etc/supervisor/supervisord.conf

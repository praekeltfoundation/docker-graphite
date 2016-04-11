FROM praekeltfoundation/supervisor
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>

# See http://graphite.readthedocs.org/en/0.9.15/install-pip.html

ENV GRAPHITE_VERSION "0.9.15"
RUN apt-get-install.sh libcairo2
# Install graphite-web dependencies from http://graphite.readthedocs.org/en/0.9.15/install.html#dependencies
# graphite-web as of version 0.9.15 doesn't set any `install_requires` in its
# setup.py so we have to install these manually.
# Use WhiteNoise to serve static files rather than Nginx -- it requires
# Django>=1.8.
RUN pip install cairocffi \
                Django>=1.8 \
                django-tagging>=0.3.1 \
                gunicorn \
                pytz \
                txAMQP \
                whitenoise
RUN pip install "whisper==${GRAPHITE_VERSION}" \
                "carbon==${GRAPHITE_VERSION}" \
                "graphite-web==${GRAPHITE_VERSION}"

# Graphite installs into /opt somehow
ENV GRAPHITE_ROOT "/opt/graphite"
ENV PATH="$PATH:$GRAPHITE_ROOT/bin"

# Set up basic config
RUN cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf && \
    cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf

# The WSGI application definition is not provided in the 0.9.x series, pull in
# from master branch: https://github.com/graphite-project/graphite-web/blob/01a1f6a8f4753a4f74356e801c0dcb16d7de33f5/webapp/graphite/wsgi.py
COPY ./wsgi.py "$GRAPHITE_ROOT/webapp/graphite"

# Copy in supervisor configs
COPY ./supervisor /etc/supervisor/conf.d

EXPOSE 8000
VOLUME /opt/graphite/storage

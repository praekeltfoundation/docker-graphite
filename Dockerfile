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
ENV PATH "$PATH:$GRAPHITE_ROOT/bin"
WORKDIR $GRAPHITE_ROOT

# Set up basic config
RUN cp conf/graphite.wsgi.example webapp/graphite/wsgi.py && \
    cp conf/carbon.conf.example conf/carbon.conf && \
    cp conf/storage-schemas.conf.example conf/storage-schemas.conf

# Copy in supervisor configs
COPY ./supervisor /etc/supervisor/conf.d

EXPOSE 8000
VOLUME /opt/graphite/storage

FROM praekeltfoundation/supervisor
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>

# See http://graphite.readthedocs.org/en/0.9.15/install-pip.html

ENV GRAPHITE_VERSION "0.9.15"
RUN apt-get-install.sh libcairo2
# Install graphite-web dependencies from https://github.com/graphite-project/graphite-web/blob/0.9.15/requirements.txt
# graphite-web as of version 0.9.15 doesn't set any `install_requires` in its
# setup.py so we have to install these manually. Also, its requirements.txt
# includes other dependencies we don't want such as Sphinx and Whisper from git
# for some reason.
# We also use Django>=1.8 instead of the recommended 1.4 as WhiteNoise requires
# it and graphite-web seems alright with Django>=1.4.
RUN pip install "Django>=1.8" \
                "python-memcached==1.47" \
                "txAMQP==0.4" \
                "simplejson==2.1.6" \
                "gunicorn" \
                "pytz" \
                "cairocffi" \
                "whitenoise"
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

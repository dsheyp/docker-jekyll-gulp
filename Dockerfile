FROM muccg/python-base:debian8-2.7
MAINTAINER https://github.com/muccg/docker-jekyll-gulp

# At build time change these args to use a local devpi mirror
# Unchanged, these defaults allow pip to behave as normal
ARG ARG_PIP_INDEX_URL="https://pypi.python.org/simple"
ARG ARG_PIP_TRUSTED_HOST="127.0.0.1"

ENV PROJECT_NAME jekyll-gulp
ENV PIP_INDEX_URL $ARG_PIP_INDEX_URL
ENV PIP_TRUSTED_HOST $ARG_PIP_TRUSTED_HOST
ENV PIP_NO_CACHE_DIR "off"

RUN env | sort

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  libgeos-c1 \
  libjpeg-dev \
  libpcre3 \
  libpcre3-dev \
  libpng12-dev \
  libpq5 \
  libpq-dev \
  libssl-dev \
  libyaml-dev \
  libxml2 \
  libxml2-dev \
  libxslt1-dev \
  python-pil \
  zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/src", "/target"]

# Drop privileges, set home for ccg-user
USER ccg-user
ENV HOME /data
WORKDIR /data

# entrypoint shell script that by default starts uwsgi
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["build"]

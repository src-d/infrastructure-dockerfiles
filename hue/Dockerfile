FROM ubuntu:bionic

ARG HUE_VERSION=4.3.0

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install --fix-missing -q -y \
    git \
    ant \
    gcc \
    g++ \
    libkrb5-dev \
    libmysqlclient-dev \
    libssl-dev \
    libsasl2-dev \
    libsasl2-modules-gssapi-mit \
    libsqlite3-dev \
    libtidy-dev \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    make \
    maven \
    libldap2-dev \
    python-dev \
    python-pip \
    python-setuptools \
    libgmp3-dev \
    libz-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/cloudera/hue.git -b release-${HUE_VERSION}
WORKDIR hue
RUN sed -i.bak 's/10.0/12.0/g' maven/pom.xml 
RUN make apps
RUN pip install psycopg2-binary

COPY ./gitbase-fix.patch .
RUN patch ./desktop/core/ext-py/MySQL-python-1.2.5/MySQLdb/connections.py gitbase-fix.patch
RUN patch /hue/build/env/local/lib/python2.7/site-packages/MySQL_python-1.2.5-py2.7-linux-x86_64.egg/MySQLdb/connections.py gitbase-fix.patch

EXPOSE 8888
VOLUME /hue/desktop/
CMD ["build/env/bin/hue", "runserver_plus", "0.0.0.0:8888"]

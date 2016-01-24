FROM ubuntu:15.10

# This is a common docker file for flow that is used to create
# containers running specific versions of an applications schema. This
# container will be running postgresql with the application's schema
# applied.

# We make an assumption that there is a file named 'install.sh' in the
# same directory as this Dockerfile that contains the instructions for
# creating the application database, user, etc.

# Each schema is intended to be in its own git repository so that we
# can link that repository to docker hub to automatically build the
# docker images following a tag of the repository.

# Example from command line:
#
#  docker build -t flowcommerce/splashpage-postgresql:0.1.2 .
#
#  docker run -d -p 5100:5432 flowcommerce/splashpage-postgresql:0.1.2
#
#  psql -U api -h 192.168.99.100 -p 5100 splashpage
#

MAINTAINER tech@flow.io

RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates postgresql-9.4

RUN apt-get install -y --no-install-recommends ca-certificates git
RUN apt-get install -y --no-install-recommends ca-certificates ruby

WORKDIR /opt
RUN git clone git://github.com/mbryzek/schema-evolution-manager.git
WORKDIR /opt/schema-evolution-manager
RUN ls
RUN git checkout 0.9.23
RUN ruby ./configure.rb --prefix /usr/local
RUN ./install.rb

RUN sed -i 's/peer/trust/' /etc/postgresql/9.4/main/pg_hba.conf
RUN sed -i 's/md5/trust/' /etc/postgresql/9.4/main/pg_hba.conf
RUN sed -i 's/127.0.0.1\/32/0.0.0.0\/0/' /etc/postgresql/9.4/main/pg_hba.conf
RUN cat /etc/postgresql/9.4/main/pg_hba.conf

RUN cat "/etc/init.d/postgresql"

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

WORKDIR /var/lib/postgresql/9.4/main
RUN ln -s /etc/postgresql/9.4/main/postgresql.conf

VOLUME /var/lib/postgresql/9.4/base
EXPOSE 5432

ADD . /opt/schema
WORKDIR /opt/schema

RUN echo "set -x #echo on" >> /opt/run.sh
RUN echo "service postgresql start" >> /opt/run.sh
RUN echo "sh /opt/schema/install.sh" >> /opt/run.sh

RUN sh /opt/run.sh

USER "postgres"
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-i", "-D", "/var/lib/postgresql/9.4/main"]

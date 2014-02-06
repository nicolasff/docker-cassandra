FROM ubuntu:precise
MAINTAINER Nicolas Favre-Felix <n.favrefelix@gmail.com>

# Install dependencies
RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes software-properties-common python-software-properties
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -y update
RUN /bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install oracle-java7-installer oracle-java7-set-default
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget dnsmasq-base python2.7 vim less iputils-ping

# Install Cassandra
ADD bin/install-cassandra /usr/bin/install-cassandra
RUN install-cassandra VERSION

# Install start scripts and hosts file
ADD bin/pipework /usr/bin/
ADD bin/start-cassandra /usr/bin/
ADD bin/run-command /usr/bin/

# Configure host names
ADD etc/cassandra.hosts /etc/dnsmasq.d/0hosts
ADD etc/dnsmasq.conf /etc/dnsmasq.conf
ADD etc/resolv.conf /etc/resolv.dnsmasq.conf

EXPOSE 9160 9042

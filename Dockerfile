
FROM phusion/baseimage:0.10.0
LABEL Name=handle_svr Version=0.0.1

## Image config

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Update installed APT packages
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN apt-get install -y ntp wget openjdk-8-jre python3

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Handle Server setup

# Get the handle server package and put it in the container
ADD http://www.handle.net/hnr-source/hsj-8.1.4.tar.gz /tmp/
RUN mkdir -p /opt/handle && tar xf /tmp/hsj-8.1.4.tar.gz -C /opt/handle --strip-components=1

# Copy over the handle base configs and build script
COPY handle/ /home/handle/

# Create the working directory for the handle server that will run in the container
RUN mkdir -p /var/handle/svr

# Install Handle server as a service
RUN mkdir /etc/service/handle
COPY handle.sh /etc/service/handle/run
RUN chmod +x /etc/service/handle/run
FROM ubuntu:latest

# Labels
LABEL maintainer="Paulino Padial <github.com/ppadial>"

# Environment variables (with default values)
ENV LOG_LEVEL=8

# Packages installation
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y autopostgresqlbackup cron bzip2 gzip postgresql-client && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*

# Copy files to the image
ADD autopostgresqlbackup.conf /etc/default/autopostgresqlbackup
ADD autopostgresqlbackup /usr/sbin/autopostgresqlbackup
RUN chmod 755 /usr/sbin/autopostgresqlbackup

# Configure entrypoint
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Volumes declaration
VOLUME ["/backup"]

# Start the container process
ENTRYPOINT ["/docker-entrypoint.sh"]

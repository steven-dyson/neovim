FROM ubuntu:24.04

ENV container=docker
ENV SHELL=/bin/bash

# Install base packages
RUN apt-get update && \
	apt-get install -y \
	systemd systemd-sysv \
	sudo wget curl git-all \
	dbus \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user if needed
RUN useradd -m -s /bin/bash dev && \
	echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working dir
WORKDIR /home/dev

# Clone your repo (as root for now)
RUN git clone --branch refactor/monorepo-again https://github.com/steven-dyson/dev-bootstrap.git

RUN chmod 775 -R /home/dev/dev-bootstrap/scripts


# Default command to launch systemd
CMD ["/sbin/init"]

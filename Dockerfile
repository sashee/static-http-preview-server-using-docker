FROM ubuntu:15.04

# Install depencencies
RUN apt-get update && apt-get upgrade
RUN apt-get install -y openssh-server nodejs npm supervisor rsync

RUN ln -s "$(which nodejs)" /usr/bin/node

# Supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure SSHD
RUN mkdir -p /var/run/sshd

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Add SSH key
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/*
RUN chown -Rf root:root /root/.ssh

# Add application files
COPY server.js /server/server.js
COPY config.json /server/config.json
COPY package.json /server/package.json
COPY form.html /server/form.html

RUN cd /server && npm install

EXPOSE 22 8080

VOLUME /preview

CMD ["/usr/bin/supervisord"]

FROM jenkins/inbound-agent
USER root
RUN apt-get -yqq update && apt-get -yqq install docker.io docker-compose
USER jenkins
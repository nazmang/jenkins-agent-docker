FROM jenkins/inbound-agent
RUN apt-get -yqq update && apt-get -yqq install docker.io docker-compose
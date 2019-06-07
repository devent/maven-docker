FROM maven:3.6.1-jdk-12
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

RUN set -x \
  && yum install -y gpg git which \
  && rm -rf /var/cache/yum

ADD rootfs/ /

ADD docker-run-utils/docker-entrypoint-utils.sh /

RUN set -x \
  && chmod +x /*.sh

ENV DEBUG="false" \
  PROJECT_JENKINS_WORKSPACE="/home/jenkins/workspace" \
  PROJECT_JENKINS_USER="10000"

ENTRYPOINT ["/docker-entrypoint.sh"]

FROM maven:3.6.1-jdk-12
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

RUN set -x \
  && yum install -y gpg git which \
  && rm -rf /var/cache/yum

ADD rootfs/ /

ADD docker-run-utils/docker-entrypoint-utils.sh /

ENV DEBUG="false" \
  PROJECT_JENKINS_HOME="/home/jenkins" \
  PROJECT_JENKINS_WORKSPACE="/home/jenkins/workspace" \
  PROJECT_JENKINS_USER="10000"

RUN set -x \
  && chmod +x /*.sh \
  && mkdir -p "${PROJECT_JENKINS_HOME}" \
  && chown ${PROJECT_JENKINS_USER}.${PROJECT_JENKINS_USER} "${PROJECT_JENKINS_HOME}" \
  && echo "jenkins:x:${PROJECT_JENKINS_USER}:${PROJECT_JENKINS_USER}::${PROJECT_JENKINS_HOME}:/bin/bash" >> /etc/passwd \
  && echo "jenkins:x:${PROJECT_JENKINS_USER}:" >> /etc/group

ENTRYPOINT ["/docker-entrypoint.sh"]

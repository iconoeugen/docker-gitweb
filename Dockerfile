FROM centos:7

MAINTAINER Horatiu Eugen Vlad "horatiu@vlad.eu"

ENV GIT_PROJECT_NAME="dummy" \
    GIT_DESCRIPTION "Dummy repository" \
    GIT_CATEGORY="" \
    GIT_OWNER="Owner" \

RUN yum -y install git gitweb httpd \
    && yum clean all

RUN mkdir /var/lib/git \
    && chown apache /var/lib/git

COPY git.conf /etc/httpd/conf.d/git.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod u+x /entrypoint.sh

EXPOSE 80 443
CMD [ "/entrypoint.sh" ]

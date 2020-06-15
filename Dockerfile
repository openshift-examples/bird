# ToDo use  RHEL
FROM centos:8 AS builder
#  yum groupinstall 'Development Tools'
# UBI  flex missing
# RUN yum install -y gcc binutils m4 make perl
RUN yum groupinstall -y 'Development Tools'
# export BIRD_VERSION=1.6.8
RUN curl -L -O https://bird.network.cz/download/bird-1.6.8.tar.gz && \
    tar xzf bird-1.6.8.tar.gz && \
    cd bird-1.6.8 && \
    ./configure --disable-client --prefix=/opt/bird-1.6.8 && \
    make install

FROM registry.access.redhat.com/ubi8/ubi-minimal AS runner

# iputils - ping
# iproute - ip command
# gettext - envsubst command
# procps  - ps command
RUN microdnf install gettext iputils iproute procps

ADD /container-scripts /container-scripts/
COPY --from=builder /opt/bird-1.6.8 /opt/bird-1.6.8
# /opt/bird-1.6.8/sbin/bird

ENV PATH=/opt/bird-1.6.8/sbin:${PATH}

RUN mkdir -p /bird/kernel && \
    chmod g+w /bird /opt/bird-1.6.8/var/run

ENV BIRD_HOST_IP="127.0.0.1"
ADD bird.conf.template /bird/bird.conf.template

EXPOSE 60179
USER 0

ENTRYPOINT ["/container-scripts/entrypoint.sh"]
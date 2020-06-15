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

RUN microdnf install gettext iputils iproute procps
# iputils - ping
# iproute - ip command
# gettext - envsubst command
# procps  - ps command

COPY --from=builder /opt/bird-1.6.8 /opt/bird-1.6.8
# /opt/bird-1.6.8/sbin/bird
ENTRYPOINT ["/opt/bird-1.6.8/sbin/bird", "-f"]
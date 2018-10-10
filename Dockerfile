# CentOS and some Libraries

# Put the main image together
FROM centos
LABEL \
 Description="Basic CentOS environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
USER 0
# Install remaining tools using yum
ADD http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm /tmp/
RUN \
  cd /tmp && rpm -Uvh epel-release*rpm && \
  yum install -y \
    cppcheck \
    hdf5-devel \
    lcov \
    libwebsockets-devel \
    spdlog-devel \
    websocketpp
USER 1001


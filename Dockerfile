# CentOS and some Libraries

# Put the main image together
FROM tafthorne/ncat-centos
LABEL \
 Description="Basic CentOS environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
USER 0
RUN \
  yum install install -y epel-release && \
  yum-config-manager --enable epel && \
  yum install -y \
    hdf5 \
    libuuid-devel


# CentOS and some Libraries

#Compile any tools we cannot install from packages
FROM tafthorne/make-devtoolset-7-toolchain-centos7 as builder
USER 0
ADD https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz /tmp/
RUN \
  yum install -y \
    automake \
    autoconf \
    clang \
    git \
    libc++-dev \
    libgflags-dev \
    libgtest-dev \
    libtool \
    which
RUN \
  # Protocol Buffer & gRPC
  # install protobuf first, then grpc
  git clone -b $(curl -L https://grpc.io/release) \
      https://github.com/grpc/grpc /var/local/git/grpc && \
    cd /var/local/git/grpc && \
    git submodule update --init && \
    echo "--- installing protobuf ---" && \
    cd third_party/protobuf && \
    ./autogen.sh && ./configure --enable-shared && \
    make -j$(nproc) && make install && make clean && ldconfig && \
    echo "--- installing grpc ---" && \
    cd /var/local/git/grpc && \
    make -j$(nproc) && make install && make clean && ldconfig

# Put the main image together
FROM tafthorne/ncat-centos
LABEL \
 Description="Basic CentOS environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
USER 0
# Copy over pre-made tools
# Protocol Buffer
COPY --from=builder /usr/local/lib/libproto* /usr/local/lib/
# gRPC
COPY --from=builder /usr/local/lib/libgrpc* /usr/local/lib/
COPY --from=builder /usr/local/lib/libaddress_sorting.so.6.0.0 /usr/local/lib/
# Install remaining tools using yum
RUN \
  yum install install -y epel-release && \
  yum-config-manager --enable epel && \
  yum install -y \
    hdf5 \
    libuuid-devel


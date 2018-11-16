# CentOS and some Libraries

#Compile any tools we cannot install from packages
FROM tafthorne/make-devtoolset-7-toolchain-centos7 as builder
USER 0
ADD https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz /tmp/
RUN \
  yum install install -y epel-release && \
  yum --setopt=skip_missing_names_on_install=False install -y \
    automake \
    autoconf \
    clang \
    git \
    gflags-devel \
    gtest-devel \
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
    make -j$(nproc) && make install && make clean && ldconfig && \
    make -j$(nproc) grpc_cli

# Put the main image together
FROM tafthorne/ncat-centos
LABEL \
 Description="Basic CentOS environment with a number of libraries configured" \
 MAINTAINER="Thomas Thorne <TafThorne@GoogleMail.com>"
ARG prefix=/usr
ARG binPath=$prefix/bin
ARG libPath=$prefix/lib
USER 0
# Copy over pre-made tools
# Protocol Buffer
COPY --from=builder /usr/local/lib/libproto* $libPath/
# gRPC
COPY --from=builder /usr/local/lib/libaddress_sorting.so.6.0.0 $libPath/
COPY --from=builder /usr/local/lib/libgpr* $libPath/
COPY --from=builder /usr/local/lib/libgrpc* $libPath/
RUN ldconfig
# grpc_cli
COPY --from=builder /var/local/git/grpc/bins/opt/grpc_cli $binPath/
# Install remaining tools using yum
RUN \
  yum install install -y epel-release && \
  yum-config-manager --enable epel && \
  yum --setopt=skip_missing_names_on_install=False install -y \
    gflags \
    hdf5 \
    libuuid-devel


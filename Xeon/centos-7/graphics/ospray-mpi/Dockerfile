

# BSD 3-Clause License
#
# Copyright (c) 2021, Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This file is automatically generated from .m4 template.
# To update, modify the template and regenerate.
FROM centos:7 AS build
RUN yum install -y -q epel-release centos-release-scl && rm -rf /var/yum/cache/*


RUN mkdir -p /opt/build && mkdir -p /opt/dist

ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig

RUN yum install -y wget gcc-c++ make libcurl-devel zlib-devel

# build cmake
ARG CMAKE_REPO=https://cmake.org/files
RUN cd /opt/build && \
    wget -O - ${CMAKE_REPO}/v3.19/cmake-3.19.4.tar.gz | tar xz && \
    cd cmake-3.19.4 && \
    ./bootstrap --prefix=/usr/local --system-curl && \
    make -j$(nproc) && \
    make install

RUN yum install -y wget

# build ISPC
ARG ISPC_REPO=https://github.com/ispc/ispc/releases/download/v1.9.1/ispc-v1.9.1b-linux.tar.gz
RUN cd /opt/build && \
  wget -O - ${ISPC_REPO} | tar xz
ENV ISPC_EXECUTABLE=/opt/build/ispc-v1.9.1-linux/ispc

RUN yum install -y wget gcc-c++ make git tbb-devel mesa-libGL-devel

# build EMBREE
ARG EMBREE_REPO=https://github.com/embree/embree.git
RUN cd /opt/build && \
    git clone ${EMBREE_REPO} && \
    mkdir embree/build && \
    cd embree/build && \
    git reset --hard df0b324 && \
    cmake .. -Wno-dev -DEMBREE_TUTORIALS=OFF && \
    make -j 8 && \
    make install DESTDIR=/opt/dist && \
    make install

RUN yum install -y gcc-c++ make git libtiff-devel zlib-devel libpng-devel libjpeg-devel python-devel boost-devel

# build OpenEXR

ARG OpenEXR_REPO=https://github.com/openexr/openexr.git
RUN cd /opt/build && \
    git clone ${OpenEXR_REPO} && \
    mkdir openexr/build && \
    cd openexr/build && \
    git reset --hard 0ac2ea3 && \
    cmake .. && \
    make -j$(nproc) && \
    make install DESTDIR=/opt/dist && \
    make install

RUN yum install -y gcc-c++ make git

# build OpenImageIO

ARG OIIO_REPO=https://github.com/OpenImageIO/oiio.git
RUN git clone ${OIIO_REPO} && \
    mkdir oiio/build && \
    cd oiio/build && \
    git reset --hard 5daa9a1 && \
    cmake .. && \
    make -j$(nproc) && \
    make install DESTDIR=/opt/dist && \
    make install

RUN yum install -y gcc-c++ make git glfw-devel mesa-dri-drivers libXrandr-devel libXinerama-devel libXcursor-devel mpich-devel openssh-server openssh-clients
# build ospray mpi
ENV PATH=$PATH:/usr/lib64/mpich/bin

ARG OSPRAY_REPO=https://github.com/ospray/ospray.git
RUN cd /opt/build && \
    git clone ${OSPRAY_REPO} ospray_mpi&& \
    mkdir ospray_mpi/build && \
    cd ospray_mpi/build && \
    git reset --hard c42a885 && \
    cmake -DOSPRAY_MODULE_MPI=ON -DOSPRAY_SG_OPENIMAGEIO=ON .. && \
    make -j$(nproc) && \
    make install DESTDIR=/opt/dist

RUN mkdir -p /var/run/sshd && \
    sed -i 's/^#Port/Port/g' /etc/ssh/sshd_config && \
    sed -i 's/^Port 22/Port 2222/g' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config && \
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#   Port 22/Port 2222/g' /etc/ssh/ssh_config && \
    echo 'root:ospray' |chpasswd && \
    sed -i 's/#   StrictHostKeyChecking ask/   StrictHostKeyChecking no/g' /etc/ssh/ssh_config && \
    /usr/bin/ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# cleanup
RUN rm -rf /opt/dist/usr/local/include && \
    rm -rf /opt/dist/usr/local/lib64/pkgconfig && \
    find /opt/dist -name "*.a" -exec rm -f {} \; || echo ""
RUN rm -rf /opt/dist/usr/local/share/doc /opt/dist/usr/local/share/gtk-doc
RUN rm -rf /opt/dist/usr/local/share/man

FROM centos:7
LABEL Description="This is the base image for ospray-oiio-mpi centos 7"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
RUN yum install -y -q epel-release && rm -rf /var/yum/cache/*

RUN yum install -y tbb libtiff-devel zlib-devel libpng-devel libjpeg-devel python-devel boost-devel 

COPY --from=build /opt/dist /
RUN echo "/usr/local/lib64" >> /etc/ld.so.conf.d/all-libs.conf && ldconfig




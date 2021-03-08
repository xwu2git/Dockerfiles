dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2021, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

ifelse(OS_NAME,ubuntu,`
define(`GVA_INSTALL_DEPS',`python3-numpy python3-gi python3-gi-cairo python3-dev ifelse(OS_VERSION,20.04,libwayland-egl1 libegl1-mesa)')
')

define(`BUILD_GVA',`
# Copy gstreamer and dl_streamer libs

ENV LIBRARY_PATH=BUILD_LIBDIR
RUN cp -r /opt/intel/openvino/data_processing/dl_streamer/lib/* BUILD_DESTDIR/usr/local/lib/gstreamer-1.0

RUN mkdir -p BUILD_DESTDIR/opt/intel/dl_streamer/python && \
    cp -r /opt/intel/openvino/data_processing/dl_streamer/python/* BUILD_DESTDIR/opt/intel/dl_streamer/python
')dnl

define(`INSTALL_GVA',
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/gstreamer-1.0
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:/usr/local/lib/gstreamer-1.0
ENV PYTHONPATH=${PYTHONPATH}:/opt/intel/dl_streamer/python
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/opt/intel/openvino/data_processing/gstreamer/lib/girepository-1.0/
)

REG(GVA)

include(end.m4)
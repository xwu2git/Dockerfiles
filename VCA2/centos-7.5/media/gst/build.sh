#!/bin/bash -e

IMAGE="vca2-centos75-media-gst"
VERSION="1.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"

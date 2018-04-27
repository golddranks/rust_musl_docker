#!/bin/sh -xe
build_docker () {
    cat Dockerfile.template |
    sed "s/RUST_TOOLCHAIN/$2/g" |\
    sed "s/OPENSSL_VER/$3/g" > Dockerfile
    docker build -t "$1":"$2_$3" .
    docker push "$1":"$2_$3"
};
build_docker "golddranks/rust_musl_docker" "nightly-2018-04-27" "openssl-1.1.0h"

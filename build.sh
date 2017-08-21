#!/bin/sh -xe
build_docker () {
    sed "s/TOOLCHAIN/$1/g" Dockerfile.template > Dockerfile
    docker build -t golddranks/rust_musl_docker:$1 .
    docker push golddranks/rust_musl_docker:$1
};
build_docker "nightly-2017-08-21"
build_docker "nightly-2017-08-21"

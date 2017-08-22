#!/bin/sh -xe
build_docker () {
    sed "s/TOOLCHAIN/$1/g" Dockerfile.template > Dockerfile
    docker build -t $1:$2 .
    docker push $1:$2
};
build_docker "golddranks/rust_musl_docker" "nightly-2017-08-21"

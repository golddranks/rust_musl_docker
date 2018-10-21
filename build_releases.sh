#!/bin/sh -xe

source build.sh

# newest beta
build_docker "golddranks/rust_musl_docker" "beta" "1.1.1" "11.0" "current-beta"

# newest stable
build_docker "golddranks/rust_musl_docker" "stable" "1.1.1" "11.0" "current-stable"

# stable with an non-changing tag
build_docker "golddranks/rust_musl_docker" "1.29.2" "1.1.1" "11.0" "stable-1.29.2"

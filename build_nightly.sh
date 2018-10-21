#!/bin/sh -xe

source build.sh


# nightly with older version of libraries
build_docker "golddranks/rust_musl_docker" "nightly-$NIGHTLY_DATE" "1.1.0i" "9.6.10" "nightly-$NIGHTLY_DATE-legacy"

# nightly
build_docker "golddranks/rust_musl_docker" "nightly-$NIGHTLY_DATE" "1.1.1" "11.0" "nightly-$NIGHTLY_DATE"

#!/bin/sh -xe
build_docker () {
    cat Dockerfile.template |
    sed "s/RUST_TOOLCHAIN/$2/g" |\
    sed "s/OPENSSL_VER/$3/g" |\
    sed "s/POSTGRES_VER/$4/g" > Dockerfile
    docker build -t "$1":"$5" .
    docker push "$1":"$5"
};

# zlib seems to update so seldom that
# it's version is hardcoded in the Dockerfile.template
# as zlib 1.2.11

# available openssl versions: "openssl-1.1.0i" and "openssl-1.1.1"

# available postgresql versions: "9.6.10", "10.5" and "11.0"

NIGHTLY_DATE=$(date -u '+%Y-%m-%d')


# PARAMS: Rust version, OpenSSL version, PostgreSQL version, tag name

# nightly with older version of libraries
build_docker "golddranks/rust_musl_docker" "nightly-$NIGHTLY_DATE" "1.1.0i" "9.6.10" "nightly-$NIGHTLY_DATE-legacy"

# nightly
build_docker "golddranks/rust_musl_docker" "nightly-$NIGHTLY_DATE" "1.1.1" "11.0" "nightly-$NIGHTLY_DATE"

# stable with an non-changing tag
build_docker "golddranks/rust_musl_docker" "1.29.2" "1.1.1" "11.0" "stable-1.29.2"

# newest beta
build_docker "golddranks/rust_musl_docker" "beta" "1.1.1" "11.0" "current-beta"

# newest stable
build_docker "golddranks/rust_musl_docker" "stable" "1.1.1" "11.0" "current-stable"

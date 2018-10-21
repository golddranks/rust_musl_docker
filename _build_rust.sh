#!/bin/sh -xe


# PARAMS: Rust version, OpenSSL version, PostgreSQL version, tag name
RUST_VER="$1"
OPENSSL_VER="$2"
POSTGRES_VER="$3"
TAG="$4"

# available openssl versions: "1.1.0i" and "1.1.1"

# available postgresql versions: "9.6.10", "10.5" and "11.0"

TEMP_DOCKERFILE="RustDockerfile.$(date '+%s').tmp"
REPO="golddranks/rust_musl_docker"

BASE_REPO="golddranks/rust_musl_docker_base"
BASE_TAG="openssl-${OPENSSL_VER}_postgres-${POSTGRES_VER}"

cat RustDockerfile.template | \
sed "s/BASE_IMAGE/$BASE_REPO:$BASE_TAG/g" | \
sed "s/RUST_TOOLCHAIN/$RUST_VER/g" > "$TEMP_DOCKERFILE"

docker build -f "$TEMP_DOCKERFILE" -t "$REPO":"$TAG" .
rm "$TEMP_DOCKERFILE"
docker push "$REPO":"$TAG"
#!/bin/sh -xe

# PARAMS: OpenSSL version, PostgreSQL version
OPENSSL_VER="$1"
POSTGRES_VER="$2"

# zlib seems to update so seldom that
# it's version is hardcoded in the BaseDockerfile.template
# as zlib 1.2.11

# available openssl versions: "1.1.0i" and "1.1.1"

# available postgresql versions: "9.6.10", "10.5" and "11.0"

TEMP_DOCKERFILE="BaseDockerfile.$(date '+%s').tmp"
REPO="golddranks/rust_musl_docker_base"
TAG="openssl-${OPENSSL_VER}_postgres-${POSTGRES_VER}"

cat BaseDockerfile.template | \
sed "s/OPENSSL_VER/$OPENSSL_VER/g" | \
sed "s/POSTGRES_VER/$POSTGRES_VER/g" > "$TEMP_DOCKERFILE"

docker build -f "$TEMP_DOCKERFILE" -t "$REPO":"$TAG" .
rm "$TEMP_DOCKERFILE"
docker push "$REPO":"$TAG"
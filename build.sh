#!/bin/sh -xe


# PARAMS: Rust version, OpenSSL version, PostgreSQL version, tag name

# zlib seems to update so seldom that
# it's version is hardcoded in the Dockerfile.template
# as zlib 1.2.11

# available openssl versions: "openssl-1.1.0i" and "openssl-1.1.1"

# available postgresql versions: "9.6.10", "10.5" and "11.0"

cat Dockerfile.template |
sed "s/RUST_TOOLCHAIN/$2/g" |\
sed "s/OPENSSL_VER/$3/g" |\
sed "s/POSTGRES_VER/$4/g" > Dockerfile
docker build -t "$1":"$5" .
docker push "$1":"$5"

FROM debian:jessie
MAINTAINER Pyry Kontio <pyry.kontio@drasa.eu>
USER root

# NOTES TO MYSELF AND OTHERS TOO, THEY MIGHT BE HELPFUL since this took me too long to figure out.

# This image is building my web app project Ganbare, written in Rust. It uses, among others, the Hyper and Diesel libraries.
# This Dockerfile is structured so that the first part is quite generic, and be easily reused. 

# I build this file with "docker build -f Dockerfile.build -t <username>/<imagename> ."
# While building, it assembles the build environment for compiling static musl binaries.
# The pain of static compiling is the native dependencies, but but correct configuration, it should be all right. You need to
# download them, build the sources with appropriate settings (I'm using the prefix /musl), and check from
# the appropriate Rust crates (usually named something-sys) how they are going to present the linking flags to Cargo.
# Read the build.rs files.

# Note: if build.rs doesn't provide options for static linking, forking the crate, and cargo-replacing it,
# and adding that functionality is a thing. (println!("cargo:rustc-link-lib=static={}", lib);, where lib is the libname
# as passed to linker [pq, ssl, crypto etc.].) But remember to contribute to upstream too!
# When run, this image compiles my project from a mounted volume.

# Some of the *-sys crates are using pkg-config to provide the linker settings. This is good, since it's easily configurable.


ENV PREFIX=/musl

# WHY THESE PACKAGES?
# optional utilities for debugging and stuff: file, nano, git
# needed utilities for installing and building everything: bzip2, curl, g++, make, pkgconf
# ca-certificates for openssl & curl. xutils-dev because it contains makedepend with is used by openssl build system

# WHAT THEN?
# Symlink libsqlite to libsqlite3.so because it's not there by default, for some reason, and it's needed by diesel_cli.
# Workdir for our code: /workdir. Prefix dir for musl-based libs and includes: /musl
RUN apt-get update && \
  apt-get install -y \
  musl-dev \
  musl-tools \
  xutils-dev \
  make \
  curl \
  pkgconf \
  git \
  g++ \
  ca-certificates \
  file \
  nano \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /workdir && mkdir $PREFIX

WORKDIR /workdir

# SETTING THE ENV VARS - WHY THESE?
# PKG_CONFIG_PATH Some of the build.rs script of *-sys crates use pkg-config to probe for libs.
# PKG_CONFIG_ALLOW_CROSS This tells the rust pkg-config crate to be enabled even when cross-compiling
# PKG_CONFIG_ALL_STATIC This tells the rust pkg-config crate to statically link the native dependencies
# The pq-sys crate doesn't use PKG_CONFIG, and we must manually pass PQ_LIB_STATIC for it to link statically.
# PATH .cargo/bin is needed for running cargo, rustup etc,
# PATH /musl/bin is needed because the build.rs of pq-sys runs a postgres binary pg_config from there that tells it the lib dir.
#     (This is just a fallback, though)
# LD_LIBRARY_PATH is needed for running compiler plugins (they are dynamically linked .so files)
#     (When target is musl, the compiler plugins are built for musl too, so we need dynamically-linked musl-libc for the plugins)
ENV PATH=$PREFIX/bin:/root/.cargo/bin:$PATH \
    PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true \
    PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig \
    PQ_LIB_STATIC=true \
    OPENSSL_STATIC=true \
    OPENSSL_DIR=$PREFIX \
    LD_LIBRARY_PATH=$PREFIX/lib \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_DIR=/etc/ssl/certs \
    CC=musl-gcc

# MAKE AND INSTALL NATIVE DEPENDENCIES

# All of these libs will be built with the musl prefix so that they won't interfere with the system glibc!
# musl must be as an .a (for static linking to produce the binary) and as an .so (for dynamic linking for the compiler plugins)

RUN install_make_project () { \
      echo "Installing a library from $1" && \
      curl -sL $1 | tar xz --strip-components=1 && \
      ./configure --prefix=$PREFIX --host=x86_64-unknown-linux-musl $2 && \
      make && make install && rm -rf * ; } ; \
    install_make_project "https://ftp.postgresql.org/pub/source/v9.6.1/postgresql-9.6.1.tar.gz" "--without-readline --without-zlib"

# OpenSSL have their own build system
RUN curl -sL http://www.openssl.org/source/openssl-1.0.2j.tar.gz | tar xz --strip-components=1 && \
    ./Configure no-shared --prefix=$PREFIX --openssldir=$PREFIX/ssl no-zlib linux-x86_64 && \
    make depend && make -j$(nproc) && make install && rm -rf *

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly && \
    rustup target add x86_64-unknown-linux-musl

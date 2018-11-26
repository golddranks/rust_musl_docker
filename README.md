# rust_musl_docker – A well-documented container for building Rust crates for MUSL target. Supports dependencies for OpenSSL and Postgres.

## NOTE: This repository is moving to GitLab. We will provide freshly built nightly docker images there! https://gitlab.com/rust_musl_docker/image

This docker image is primarily meant for building statically Rust crates that use **Diesel** and **Rocket** libraries.
A combination of static linking, native (C) dependencies and crates that use heavily compiler plugins is hard to get to
compile. (1) This Docker image is meant to help with that. Not only it supports Diesel and Rocket (and many other crates)
directly, it also is fully commented to help for possible customisation needs. There exists other similar images too,
but the lack of comments make them unhelpful if they don't happen to contain the exact things you need.

`Dockerfile.template` is fully commented! Please read it for details.

## USAGE:

Run this container (you can do that directly but I recommend writing a build script) from your project dir.

Mount the current work dir (`-v $PWD:/workdir`) and Cargo cache dirs (`-v ~/.cargo/git:/root/.cargo/git` &
`-v ~/.cargo/registry:/root/.cargo/registry`) to be able to reuse the cache.

You can customise the build command; in this example, it builds the release build super-verbosely for musl target.
I'll occasionally build new images for new nightlies, but you can do that yourself too, editing and running the build.sh
script.


```
docker run -it --rm \
    -v $PWD:/workdir \
    -v ~/.cargo/git:/root/.cargo/git \
    -v ~/.cargo/registry:/root/.cargo/registry \
    golddranks/rust_musl_docker:nightly-2018-05-09_openssl-1.1.0h \
    cargo build --release -vv --target=x86_64-unknown-linux-musl
```

(1) This has gotten even harder as of late, with Debian Stretch moving to position-independent-code by default and the Rust compiler enabling RELRO. Fortunately, after a lot of trial and error, the build enviroment works.

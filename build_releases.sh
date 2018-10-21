#!/bin/sh -xe


# newest beta
./build.sh "golddranks/rust_musl_docker" "beta" "1.1.1" "11.0" "current-beta"

# newest stable
./build.sh "golddranks/rust_musl_docker" "stable" "1.1.1" "11.0" "current-stable"

# stable with an non-changing tag
./build.sh "golddranks/rust_musl_docker" "1.29.2" "1.1.1" "11.0" "stable-1.29.2"

#!/bin/sh -xe


# newest beta
./_build_rust.sh "beta" "1.1.1" "11.0" "beta-latest"

# newest stable
./_build_rust.sh "stable" "1.1.1" "11.0" "stable-latest"

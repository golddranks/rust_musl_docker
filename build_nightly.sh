#!/bin/sh -xe


NIGHTLY_DATE=$(date -u '+%Y-%m-%d')

# nightly with older version of libraries
./_build_rust.sh "nightly-$NIGHTLY_DATE" "1.1.0i" "9.6.10" "nightly-$NIGHTLY_DATE-legacy"

# nightly
./_build_rust.sh "nightly-$NIGHTLY_DATE" "1.1.1" "11.0" "nightly-$NIGHTLY_DATE"

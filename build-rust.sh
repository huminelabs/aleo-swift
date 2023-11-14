#!/bin/bash

set -e

THISDIR=$(dirname $0)
cd $THISDIR

# Build the project for the desired platforms:
cargo build --target x86_64-apple-darwin
cargo build --target aarch64-apple-darwin
mkdir -p ./target/universal-macos/debug

lipo \
    ./target/aarch64-apple-darwin/debug/libaleo_swift.a \
    ./target/x86_64-apple-darwin/debug/libaleo_swift.a -create -output \
    ./target/universal-macos/debug/libaleo_swift.a

cargo build --target aarch64-apple-ios

cargo build --target x86_64-apple-ios
cargo build --target aarch64-apple-ios-sim
mkdir -p ./target/universal-ios/debug

lipo \
    ./target/aarch64-apple-ios-sim/debug/libaleo_swift.a \
    ./target/x86_64-apple-ios/debug/libaleo_swift.a -create -output \
    ./target/universal-ios/debug/libaleo_swift.a
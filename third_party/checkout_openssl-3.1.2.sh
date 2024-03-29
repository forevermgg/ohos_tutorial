#!/bin/bash

# Clone OpenSSL repository
git clone https://github.com/openssl/openssl.git

# Change directory to openssl
cd openssl

# Fetch all the tags from the remote repository
git fetch --tags

# Checkout tag 3.1.2
git checkout tags/openssl-3.1.2

# Verify the tag has been checked out
git describe --tags
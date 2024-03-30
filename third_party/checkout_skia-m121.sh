#!/bin/bash

# Clone Skia repository
git clone https://github.com/google/skia.git

# Change directory to Skia
cd skia

# Fetch all the tags from the remote repository
git fetch origin

git -c advice.detachedHead=false checkout 589c46555055ec23bcc4634c209f7f543f6b424c

python3 tools/git-sync-deps
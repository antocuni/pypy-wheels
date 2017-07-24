#!/bin/bash

cd "$(dirname "$0")"
cat $(git ls-files) | md5sum | head -c 8

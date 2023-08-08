#!/bin/sh
set -ve
nim c -d:release -r rtnim.nim > foo.ppm && open foo.ppm

#!/bin/sh
set -ve
nim c -r rtnim.nim > foo.ppm && open foo.ppm

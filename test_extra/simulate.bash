#!/usr/bin/env bash

set -Eeuo pipefail  # See the meaning in scripts/README.md
# set -x  # Print each command

rm -rf run
mkdir  run
cd     run

iverilog -g2005-sv -s tb          \
    -I ..      -I ../../src       \
       ../*.sv    ../../src/*.sv  \
    |& tee ../log.txt

vvp a.out |& tee ../log.txt

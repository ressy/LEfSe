#!/usr/bin/env bash

# Simple test script using the example input data.  Needs dependencies supplied
# via Anaconda or somewhere.

set -ex

DIR=$(readlink -f $(dirname $BASH_SOURCE))
export PATH="$DIR:$PATH"

mkdir -p "$DIR/testrun"
pushd "$DIR/testrun"

# Set up input data and clean up any previous outputs
DATA=hmp_aerobiosis_small.txt
[ -e $DATA ] || \
	wget http://huttenhower.sph.harvard.edu/webfm_send/129 -O $DATA

# Check exact match for expected .res file
format_input.py $DATA ${DATA%.txt}.in -c 1 -s 2 -u 3 -o 1000000
run_lefse.py ${DATA%.txt}.in ${DATA%.txt}.res
md5sum -c <(echo "68e3c1e091bfe40a06368c48c89b9103  ${DATA%.txt}.res")

# Just make sure some other commands run without error
plot_res.py ${DATA%.txt}.res ${DATA%.txt}.png
plot_cladogram.py ${DATA%.txt}.res ${DATA%.txt}.cladogram.png --format png
mkdir biomarkers_raw_images
plot_features.py ${DATA%.txt}.in ${DATA%.txt}.res biomarkers_raw_images/

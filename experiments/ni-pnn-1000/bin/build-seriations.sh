#!/bin/sh

set -o errexit

mkdir -p data/seriation-output

### EDIT PARALLELISM to match the parallelism chosen in build-simulations.sh given the number of simulations,
### or to match the number of post processing output files if this multiplies over the number of simulations.

seriationct-seriation-builder.py --inputdirectory data/filtered-data \
	--outputdirectory data/seriation-output \
	--dobootstrapsignificance 1 \
	--frequency 0 \
	--continuity 1 \
	--experiment ni-pnn-1000 \
	--jobdirectory jobs \
	--parallelism 300 \
	--debug 0



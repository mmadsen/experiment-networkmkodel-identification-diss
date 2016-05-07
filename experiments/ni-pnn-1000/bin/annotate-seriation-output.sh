#!/bin/sh

set -o errexit

######## Annotate linear seriation results ########

seriationct-annotate-minmax-graph.py \
    --modeltype lineage \
    --experiment ni-pnn-1000 \
    --addlabel ni-pnn-1000 \
    --debug 0





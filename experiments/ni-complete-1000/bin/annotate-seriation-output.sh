#!/bin/sh

set -o errexit

######## Annotate linear seriation results ########

seriationct-annotate-minmax-graph.py \
    --modeltype lineage \
    --experiment ni-complete-1000 \
    --addlabel ni-complete-1000 \
    --debug 0





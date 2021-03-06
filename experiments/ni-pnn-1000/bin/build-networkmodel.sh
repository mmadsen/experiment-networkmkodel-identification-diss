#!/bin/sh

set -o errexit

echo "========================================================="
echo "  Sampling random network models from config"
echo "========================================================="

mkdir -p data/rawnetworkmodels
mkdir -p data/networkmodels
mkdir -p data/xyfiles


seriationct-sampler-spatial-neighbor.py \
    --experiment ni-pnn-1000 \
    --netmodelconfig network-model-configuration-nnmodel.json \
    --rawnetworkmodelspath data/rawnetworkmodels \
    --compressednetworkmodelspath data/networkmodels \
    --xyfilespath data/xyfiles \
    --nummodels 100 \
    --debug 0





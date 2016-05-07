#!/bin/sh
rm -f experiment-index.md

echo "# Seriation Classification Experiment (serclassification) Index #" >> experiment-index.md
echo " " >> experiment-index.md

for d in `ls -d sc-*`; do ( cd $d; cat README.md >> ../experiment-index.md; cd ..); done

pandoc -o experiment-index.html experiment-index.md


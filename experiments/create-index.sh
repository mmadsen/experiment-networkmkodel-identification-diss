#!/bin/sh
rm -f experiment-index.md

echo "# Network Identification from Seriation:  Experiment Index #" >> experiment-index.md
echo " " >> experiment-index.md

for d in `find . -type d`; do ( cd $d; cat README.md >> ../experiment-index.md; cd ..); done

pandoc -o experiment-index.html experiment-index.md


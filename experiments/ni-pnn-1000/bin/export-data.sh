#!/bin/sh

set -o errexit

mkdir -p data/exported-data
mkdir -p data/temporal

cat << EOF > /tmp/mongo-index
use ni-pnn-1000_samples_raw;
db.seriationct_sample_unaveraged.ensureIndex( { simulation_run_id: 1 })
EOF

mongo < /tmp/mongo-index
rm /tmp/mongo-index

echo "=================== exporting simulation data =============="

seriationct-export-simids.py --experiment ni-pnn-1000 --outputfile data/simids.txt
for d in `cat data/simids.txt`;
do ( 
	#echo "export $d"
	seriationct-export-single-simulation.py --experiment ni-pnn-1000 \
		--outputdirectory data/exported-data \
		--simid $d 
); done


echo "=============== exporting temporal information on assemblages ==============="

seriationct-assemblage-duration-export.py --experiment ni-pnn-1000 \
    --outputdirectory data/temporal
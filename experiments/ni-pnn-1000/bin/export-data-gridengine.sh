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

seriationct-simulation-export-builder.py --experiment ni-pnn-1000 \
    --simidfile data/simids.txt --outputdirectory data/exported-data --parallelism 100

echo "=============== exporting temporal information on assemblages ==============="

seriationct-assemblage-duration-export.py --experiment ni-pnn-1000 \
    --outputdirectory data/temporal



echo "=============== running export jobs through Grid Engine ================="

for d in `ls jobs/export*.sh`
do
        qsub -V -cwd $d
done

# just a default value, but this is often what we run at a time given core count
count=10

while [ $count -ne 0 ]
do
	sleep 60
	count=`qstat | wc -l`
	echo "still $count exports running in gridengine"
done

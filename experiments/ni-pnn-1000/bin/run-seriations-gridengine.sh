#!/bin/sh

set -o errexit

for d in `ls jobs/seriationjob*.sh`
do
        qsub -V -cwd $d
done

# just a default value, but this is often what we run at a time given core count
count=10

while [ $count -ne 0 ]
do
	sleep 60
	count=`qstat | wc -l`
	echo "still $count seriations running in gridengine"
done


#!/bin/sh

set -o errexit

for d in `ls jobs/seriationjob*.sh`; do ( sh $d ); done
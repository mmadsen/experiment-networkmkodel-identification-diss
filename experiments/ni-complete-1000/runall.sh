#!/bin/sh

# exit if any of the subcommands returns an error, since they only work if the preceding command succeeded
set -e
set -o errexit

sh bin/build-networkmodel.sh

sh bin/build-simulations.sh
#sh bin/run-simulations.sh
sh bin/run-simulations-gridengine.sh

sh bin/export-data-gridengine.sh
sh bin/simulation-postprocess-gridengine.sh

sh bin/build-seriations.sh
sh bin/run-seriations-gridengine.sh
#sh bin/run-seriations.sh

sh bin/annotate-seriation-output.sh

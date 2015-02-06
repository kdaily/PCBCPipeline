#!/bin/bash
#
cd $SGE_O_WORKDIR
workon snakemake
snakemake --jobname 's.{jobid}.{rulename}' --js jobscript.sh -k --stats snakemake.stats -T --rerun-incomplete -j 300 --cluster 'qsub {params.batch}'  >&  snakemake.log

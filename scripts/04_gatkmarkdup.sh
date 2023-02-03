#!/bin/bash
##SBATCH stuff
##SBATCH stuff
##SBATCH stuff
##SBATCH stuff
##SBATCH stuff
##SBATCH stuff
##SBATCH stuff
##SBATCH stuff
##SBATCH stuff

#load variables
source $paramfile

#activate parallel
. ssmuse-sh -x main/opt/parallel/parallel-20210922

#export variables to keep parallel happy
export gatk
export projdir

#deduplicate in parallel
cat $projdir/sets/$set | \
  parallel --tmpdir $projdir/gatktemp \
  --jobs 14 \
  '$gatk  --java-options "-Xmx5G" \
  MarkDuplicates \
  I=align/{}.sorted.bam \
  O=align/{}.deDup.bam M=align/{}_deDupMetrics.txt \
  REMOVE_DUPLICATES=true \
  TMP_DIR=$projdir/gatktemp '

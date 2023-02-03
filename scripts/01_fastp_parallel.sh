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

#source conda
source ~/miniconda3/etc/profile.d/conda.sh

#load variables
source $paramfile

#load GNU parallel in special gpsc way
. ssmuse-sh -x main/opt/parallel/parallel-20210922

conda activate fastp

#export to make parallel happy
export fastp
export projdir
export set

#run in parallel
cat $projdir/sets/$set | \
  parallel -j 16 \
  ' fastp -i $projdir/reads/{}_R1.fastq.gz \
  -I $projdir/reads/{}_R2.fastq.gz \
  --cut_right \
  --cut_right_window_size 4 \
  --cut_right_mean_quality 20 \
  -o $projdir/trim/{}_R1.trimmed.fastq.gz \
  -O $projdir/trim/{}_R2.trimmed.fastq.gz \
  --thread 4 '

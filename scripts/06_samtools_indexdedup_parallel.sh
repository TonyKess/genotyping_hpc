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

#source conda
source ~/miniconda3/etc/profile.d/conda.sh

conda activate align

#activate parallel
. ssmuse-sh -x main/opt/parallel/parallel-20210922

##export to keep parallel happy
export projdir

cat $projdir/sets/$set | \
   parallel --jobs 64  'samtools index align/{}.deDup.bam '

conda deactivate

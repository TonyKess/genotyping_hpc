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

#source mamba
source ~/.bashrc

mamba activate align

#activate parallel
. ssmuse-sh -x main/opt/parallel/parallel-20210922

##export to keep parallel happy
export projdir

cat $projdir/sets/$set | \
   parallel --jobs 64  'samtools index align/{}.deDup.bam '

conda deactivate

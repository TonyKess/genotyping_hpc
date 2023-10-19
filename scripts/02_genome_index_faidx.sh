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
#get source data
source $paramfile

#source conda
source ~/.bashrc
mamba activate align

#index a couple of different ways
bwa-mem2 index $genome
samtools faidx $genome

conda deactivate

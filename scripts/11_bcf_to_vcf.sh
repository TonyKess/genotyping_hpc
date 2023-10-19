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
source $angsdparam

#source mamba
source ~/.bashrc

#activate the alignment environment
mamba activate align

bcftools view $projdir/angsd_out/$species.$projname.$runname.$chrom.bcf > $projdir/angsd_out/$species.$projname.$runname.$chrom.vcf

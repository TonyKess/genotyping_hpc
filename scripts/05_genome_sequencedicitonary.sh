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
##SBATCH stuff

#get source data
source $paramfile

#make a sequence dictionary using gatk
$gatk CreateSequenceDictionary -R $genome

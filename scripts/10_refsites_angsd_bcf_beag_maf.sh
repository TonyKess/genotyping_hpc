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

#source conda
source ~/miniconda3/etc/profile.d/conda.sh

#activate the alignment environment
conda activate align
cd $projdir/angsd_in

angsd \
  -nThreads 8 \
  -bam $bamfile \
  -out $projdir/angsd_out/$species.$projname.$runname.$chrom \
  -dobcf 1 \
  -gl 1 \
  -dopost 1 \
  -dogeno 5 \
  -doGlf 2 \
  -domajorminor 1 \
  -domaf 1 \
  -docounts 1 \
  -dumpCounts 2 \
  -doQsDist 1 \
  -minMapQ 30 \
  -minQ 30 \
  -uniqueOnly 1 \
  -r $chrom \
  -sites $sites \
  -remove_bads 1 \
  -only_proper_pairs 1

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

mamba activate align
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
  -minInd $minInd \
  -SNP_pval 2e-6 \
  -uniqueOnly 1 \
  -minMaf 0.05 \
  -setMinDepth $minDepth \
  -r $chrom \
  -remove_bads 1 \
  -only_proper_pairs 1

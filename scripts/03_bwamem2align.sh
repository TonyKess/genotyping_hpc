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

#ensure you are in your home directory - this script assumes starting in /home/user
#load variables
source $paramfile

#source conda
source ~/miniconda3/etc/profile.d/conda.sh

conda activate align

#change directory and align all reads
cd $projdir/trim

while read ind;
  do echo $ind\.bam ;
  RGID=$(echo $ind |  sed 's/i5.*/i5/') ;
  SMID=$(echo $ind | sed 's/NS.*i5.//') ;
  LBID=$(echo $ind | sed 's/.UDP.*//');
  bwa-mem2 mem \
  -t 64 \
  -R "@RG\tID:$RGID\tSM:$SMID\tLB:$LBID" \
  $genome \
  $ind\_R1.trimmed.fastq.gz  $ind\_R2.trimmed.fastq.gz\
  | samtools sort -o $projdir/align/$ind\.sorted.bam -T $ind -@ 64 -m 2G ;
  done <  $projdir/sets/$set


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

conda activate gatk37

#activate parallel
. ssmuse-sh -x main/opt/parallel/parallel-20210922

##export to keep parallel happy
export gatk37
export projdir
export genome

cat $projdir/sets/$set | \
   parallel --tmpdir $projdir/gatktemp \
   --jobs 64 \
  ' java -Xmx5g \
  -Djava.io.tmpdir=$projdir/gatktemp\
  -jar $gatk37  \
  -T RealignerTargetCreator \
  -R $genome \
  -I align/{}.deDup.bam \
  -o align/{}.intervals'

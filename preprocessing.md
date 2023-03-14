Raw sequence data requires pre-processing to be used in genotyping pipelines. You would think someone would have dealt with this issue in a single consolidated software package, and that is [kind of true](https://nf-co.re/sarek). But projects in "non-model" species (e.g. everything) often have lots of small analysis decisions that require working closely with the data, so we are going to run these steps ourselves! Working with pre-configured pipelines also often requires prior knowledge of what the tools are actually doing, and what their inputs/outputs and errors look like. The scripts for running these on a SLURM cluster are listed [here](https://github.com/TonyKess/genotyping_hpc/tree/main/scripts). 

Eventually we can combine these into a single workflow for reproducibility and solve the problem of genotyping permanently and everyone can move on to working on other problems rather than building wrappers around their own preferred toolset for genotyping data used in their research. [ha](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7111497/) [ha](https://academic.oup.com/bioinformatics/article/34/1/107/4096362) [just](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling) [kidding](https://www.nature.com/articles/nmeth.3505). 

It's still worth packaging tools as a workflow where possible, and these are great resources that have been developed, but often each project has different suites of tools that need to be tested and run.

This section provides links for running tools we have used for genotyping fisheries species, with an emphasis on handling low and medium coverage data through working with genotype likelihoods and imputation. We run these tools in [SLURM](https://slurm.schedmd.com/documentation.html) and a bit of background on why we run them in a specific order.

First, we need to set up the directory structure:
  
```
mkdir sets
mkdir trim
mkdir align
mkdir angsd_out
mkdir gatk_out
mkdir phased
mkdir GWAS
mkdir PCANGSD_out 
```
We assume our reads are already hanging out in the aptly named
  
```
reads/
```

Go to the raw reads and use split to make set files for parallel SLURM jobs. For low depth sequencing or small genomes, we can make large set files: 

 ``` 
cd reads
  
ls *R1.fastq.gz | \
  sed 's/\_R1.fastq.gz//' > ../sets/aeipinds.tsv 
  
 split -l 100 \
  -d \
 ../sets/aeipinds.tsv \
 ../sets/aeipset

```

For large per-individual datasets (high genomic coverage, large genome, both), we need to make smaller sets:
   
``` 
cd reads
  
ls *R1.fastq.gz | \
  sed 's/\_R1.fastq.gz//' > ../sets/aeipphaseinds.tsv 
  
 split -l 15 \
  -d \
 ../sets/aeipphaseinds.tsv \
 ../sets/aeipphaseset

```
  
  
Make/edit a file with parameters for analysis (WGSparams_aeip.tsv and here), and use it for launching analyses via SLURM scheduling.  
  
Launch the first script in the analysis pipeline, using default trimming parameters in [fastp](https://github.com/OpenGene/fastp) to remove adapter content, and add a sliding window function to remove polyG tails, as suggested by [Lou et al. 2022](https://doi.org/10.1111/1755-0998.13559). This script will be launched to run in parallel on all individuals, 100 at a time for low depth samples, 15 at a time for our high depth phasing panel.

```
for i in {00..07} ;    do sbatch --export=ALL,set=aeipset$i,paramfile=WGSparams_aeip.tsv 01_fastp_parallel.sh ;  done
```
And 15 individuals at a time for high depth samples:

```
 for i in {00..07} ;    do sbatch --export=ALL,set=aeipphaseset$i,paramfile=WGSparams_aeipphase.tsv 01_fastp_parallel.sh ;  done
```
There is a tradeoff for adapter trimming and parallelizing with fastp - it does not become much more efficient at anything beyond [4 threads](https://hpc.nih.gov/training/gatk_tutorial/preproc.html#preproc-single-tools). So we run our each on a single node and allocate 4 threads per task, with 16 separate jobs running. Our script will look like this:
  
 ```
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
  ```
Different tasks will have different optimal settings for parallelization and multithreading, which I will try to indicate at each step.
     
Next, we need to index the genome for alignment and alignment cleanup. We only need to do this once per genome, like so:

```
sbatch --export=ALL,paramfile=WGSparams_aeip.tsv 02_genome_index_faidx.sh
```
Now we can get to aligning our reads against the reference genome. This process gains from additional threads (and does weird stuff when you run it with GNU parallel...) so we take up a whole node per run, with 64 cpus. 
 
```
for i in {00..07} ;    do sbatch --export=ALL,set=aeipset$i,paramfile=WGSparams_aeip.tsv 03_bwamem2align.sh ;  done
for i in {00..07} ;    do sbatch --export=ALL,set=aeipphaseset$i,paramfile=WGSparams_aeipphase.tsv 03_bwamem2align.sh ;  done
  
```
Next, we remove sequence duplicates using the genome analysis toolkit. Two things to make sure of in advance. First, we need to make a directory for the temporary files produced by gatk:

```
mkdir gatktemp
```
I make separate ones for each project but you can also just point to a single location across scripts.
The other thing worth doing is optimizing the number of threads utilized per run based on file size. The GATK tools don't usually make use of multithreading, so it's often more efficient to just allocate a single cpu/task and then run those tasks [simultaneously.](https://en.wikipedia.org/wiki/Embarrassingly_parallel) For the high depth samples this means fewer total CPUs/run of the script.We adjust these parameters in the sbatch commands:

```
#SBATCH --cpus-per-task=15  
```

and passed to GNU parallel:

```
parallel --jobs 15
```
  
Then, just like other tasks, we can launch the jobs for all samples simulatenously.

```
for i in {00..07} ;    do sbatch --export=ALL,set=aeipset$i,paramfile=WGSparams_aeip.tsv 04_gatkmarkdup.sh ;  done
for i in {00..07} ;    do sbatch --export=ALL,set=aeipphaseset$i,paramfile=WGSparams_aeipphase.tsv 04_gatkmarkdup.shh ;  done
```

At the same time, we are going to start needing a sequence dictionary for indel realignemt. So we can also do that now, just once per reference genome.
 
```
sbatch --export=ALL,paramfile=WGSparas_aeip.tsv 05_genome_sequencedicitonary.sh
```

For realignment around insertsions/deletions, we will first need to index the deduplicated alignment files we are working from. Again, we will adjust the number of CPUs to the batch size and run with 1 cpu/sample. 

```
for i in {00..07} ;    do sbatch --export=ALL,set=aeipset$i,paramfile=WGSparams_aeip.tsv 06_samtools_indexdedup_parallel.sh ;  done
for i in {00..07} ;    do sbatch --export=ALL,set=aeipphaseset$i,paramfile=WGSparams_aeipphase.tsv 06_samtools_indexdedup_parallel.sh ;  done
```

Now we can get to actually realigning! Worth nothing this step is from a deprecated version of GATK, but because we are going to do our SNP calling and analysis of genotype likelihoods in ANGSD, we still need to realign. This can be done in a couple of steps, first identifying realignment targets:

```
for i in {00..07} ;    do sbatch --export=ALL,set=aeipset$i,paramfile=WGSparams_aeip.tsv 07_indel_target_parallel.sh ;  done
for i in {00..07} ;    do sbatch --export=ALL,set=aeipphaseset$i,paramfile=WGSparams_aeipphase.tsv 07_indel_target_parallel.sh ;  done
```
And then updating those alignments:  
```
for i in {00..07} ;    do sbatch --export=ALL,set=aeipset$i,paramfile=WGSparams_aeip.tsv  08_indel_realign_parallel.sh ;  done
for i in {00..07} ;    do sbatch --export=ALL,set=aeipphaseset$i,paramfile=WGSparams_aeipphase.tsv  08_indel_realign_parallel.sh ;  done
```  

This should cover all of the pre-processing steps, and we are ready to move on to the [confusing realm](https://github.com/ANGSD/angsd/issues) of ectracting genotype likelihoods from ANGSD.

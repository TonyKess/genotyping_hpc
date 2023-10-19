# Genotyping in an HPC environment
## Preamble
### What is this
This repo is to provide example code for a training module on running a genotyping and genotype likelihoods pipeline in an HPC environment. Go here varying versions of the code used in [Atlantic Salmon](https://github.com/TonyKess/seaage_GWAS) and [Lumpfish](https://github.com/tonyKess/lumpfish). Go here for info on how these tools will run in a cloud virtual [machine](https://github.com/tonyKess/cloudgenomics/). The code used here is to show *one* way of running a genotyping pipeline with a specific set of tools. There are many different ways to approach genotyping, but the general steps involve some version of: [cleaning up raw reads, aligning them to a genome, updating and improving those alignments a bit, and calling variant sites of different kinds.](https://gatk.broadinstitute.org/hc/en-us/articles/360035894711-About-the-GATK-Best-Practices). Often these approaches are cited as the "GATK best practices", but they're definitely not, unless it's a human medical genomics project.



Also some misc. links that cover tools used that I have found helpful:

GATK [parallelism and multithreading](https://sites.google.com/a/broadinstitute.org/legacy-gatk-documentation/dictionary/1988-Parallelism?pli=1)

GATK [best practices in practice](https://hpc.nih.gov/training/gatk_tutorial/)

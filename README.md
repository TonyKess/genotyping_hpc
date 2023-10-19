# Genotyping in an HPC environment
## Preamble
### What is this?
This repo is to provide example code for a training module on running a genotyping and genotype likelihoods pipeline in an HPC environment. It also works other places. Go here for varying versions of the code used in [Atlantic Salmon](https://github.com/TonyKess/seaage_GWAS) and [Lumpfish](https://github.com/tonyKess/lumpfish). Go here for info on how these tools will run in a cloud virtual [machine](https://github.com/tonyKess/cloudgenomics/). The code used here is to show *one* way of running a genotyping pipeline with a specific set of tools. There are many different ways to approach genotyping, but the general steps involve some version of: [cleaning up raw reads, aligning them to a genome, updating and improving those alignments a bit, and calling variant sites of different kinds.](https://gatk.broadinstitute.org/hc/en-us/articles/360035894711-About-the-GATK-Best-Practices). Often these approaches are cited as the "GATK best practices", but they're definitely not, unless it's a human medical genomics project. [This paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3593722/) remains my go-to manuscript for getting a better handle on the general ideas underlying most of these steps.

### What isn't this!?
The point of this repo and training is not to turn you into an expert bioinformatcian, or software engineer. I definitely don't expect that of myself, and this code won't get you there. The goal here is build some general familiarty with genomic data processing, genotyping tools, and submitting jobs to a cluster. There is likely a tradeoff in time investment with developing elegant code and generating biologically and scientifically meaningful results:

![Bioinformatics_laffercurve](https://github.com/TonyKess/genotyping_hpc/assets/33424749/732540f7-8485-4b9c-b812-75490b851696)

But building these skills can be rewarding and fun. So, my only advice here is try to pick up new things while developing code that looks *good enough* to you to get the information from the natural world that you care about.

### Misc

Also some misc. links that cover tools used that I have found helpful:

[The most useful (and basically only) training resource I've used](http://korflab.ucdavis.edu/unix_and_perl/).

GATK [parallelism and multithreading](https://sites.google.com/a/broadinstitute.org/legacy-gatk-documentation/dictionary/1988-Parallelism?pli=1)

GATK [best practices in practice](https://hpc.nih.gov/training/gatk_tutorial/)


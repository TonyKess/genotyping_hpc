This section details how to build the conda environments, download key software, and access supplementary information that is required for the HPC genotyping workflow. 

# Using Mamba to Install Software via Bioconda
[Mamba](https://github.com/mamba-org/mamba) is a fast and parallel implementation of the package management tool [conda](https://docs.conda.io/projects/conda/en/stable/#)
More information on installing conda can be found [here](https://github.com/GRDI-GenARCC/tutorials-and-workshops/blob/main/Conda/conda_installation_guide.md)

Mamba is a package manager that allows you to install and manage software packages in an HPC system. To use mamba to install software via Bioconda, you need to first install mamba.

You can install mamba using the following command:

```bash
conda install mamba -c conda-forge
```

Alternatively, you can download from conda-forge directly:

```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
```

Now we activate and install:
```bash
chmod +x Mambaforge-Linux-x86_64.sh
./Mambaforge-Linux-x86_64.sh
```

Now we can start installing software needed! 
Ths first thing we'll want to do with our data is run quality and adapter trimming. We can use fastp to do this

```
mamba create -n fastp fastp -c bioconda
```

Make an environment for alignment of reads to the reference genome, as well as working with genotype likelihoods in ANGSD. These are imported together to ensure version comaptibility between ANGSD and the corresponding htslib and samtools installs. 

```
mamba create -n align samtools htslib bwa bwa-mem2 angsd -c bioconda
```

Next we need different versions of software for genotyping and pre-genotyping processes, that are not present in useful versions in bioconda. I like to store these in:
```
/software
```

ANGSD works with inputs from older versions of GATK, whereas we can directly carry out genotyping in the current version of GATK. To get the old verison (3.7), we do:

```
wget https://storage.googleapis.com/gatk-software/package-archive/gatk/GenomeAnalysisTK-3.7-0-gcfedb67.tar.bz2
bzip2 -d GenomeAnalysisTK-3.7-0-gcfedb67.tar.bz2
tar -xvf
```
This version of GATK also needs its own, older version of java that we can install using conda. 
```
mamba create -n gatk37 openjdk=8
```

To get the current version of GATK, we do:

```
wget https://github.com/broadinstitute/gatk/releases/download/4.3.0.0/gatk-4.3.0.0.zip
unzip gatk-4.3.0.0.zip
tar -xvf
```

Additionally, we need a reference genome for our study species. Here is an example pull of the  with the Atlantic Salmon genome:

```
curl -OJX GET "https://api.ncbi.nlm.nih.gov/datasets/v1/genome/accession/GCF_905237065.1/download?include_annotation_type=GENOME_GFF,RNA_FASTA,CDS_FASTA,PROT_FASTA&filename=GCF_905237065.1.zip" -H "Accept: application/zip"
```
Genomes and the associated download commands can be found in NCBI datasets [here](https://www.ncbi.nlm.nih.gov/datasets/genome/)

We will calculate [genotype likelihoods](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3593722/), which are uncertainty-weighted estimates of an individual's genotype at a locus. We will carry this out across each chromosome separately, because it is somewhat memory and time intensive. Notice that we are now exporting a couple of different variables to slurm - we are specifying chromosome rather than set, and some run-specific parameters that we keep in another params file.

```
while read chrom;  do sbatch --export=ALL,chrom=$chrom,paramfile=WGSparams_aeip.tsv,angsdparam=refs_angsdparam.tsv  09_angsd_bcf_beag_maf.sh ;  
  done < Ssal_v3.1_genomic.chroms
```
We are doing this first for a set of individuals sequenced at high coverage. The ANGSD command looks like this:

```
cd projdir/angsd_in

$angsd \
  -nThreads 8 \
  -bam $bamfile \
  -out $projdir/angsd_out/$species.$projname.$runname.$chrom. \
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
 ```
Most of it won't change, but we can use sites genotyped at high coverage for better imputation (potentially? We'll see). To get these sites after the first genotyping run, we do the following:

```
zcat *mafs.gz  | sort | uniq | cut -f1,2,3,4 | sed '$d' > All_sites.tsv
```

Which will open up all the allele frequency estimates from each chromosome, sort them and remove duplicate headers, and then drop the header that gets sorted to the bottom of the file.  Then we index these sites using ANGSD:

```
conda activate align
angsd sites index All_sites.tsv
conda deactivate 
```
We can add this information to the parameter file for our lcWGS samples:

```
bamfile=lcbams.tsv
runname=lcwgs
minInd=600
minDepth=1000
sites=All_sites.tsv
```
And then also add the --sites $sites option to our ANGSD call for these samples. Because we are specifying another option for ANGSD, we run a new script that now includes the site option:

```
while read chrom;  do sbatch --export=ALL,chrom=$chrom,paramfile=WGSparams_aeip.tsv,angsdparam=lcwgs_angsdparam.tsv  10_refsites_angsd_bcf_beag_maf.sh ;  
  done < Ssal_v3.1_genomic.chroms 
```

Now we have a bunch of kinda useless bcf files. They're smaller than vcfs but they lack human interpretable info, so we need to convert them to vcfs. We do this per bcf file, so we again specify the chromosome and file set.

```
while read chrom;  do sbatch --export=ALL,chrom=$chrom,paramfile=WGSparams_aeip.tsv,angsdparam=refs_angsdparam.tsv  11_bcf_to_vcf.sh ;  
  done < Ssal_v3.1_genomic.chroms


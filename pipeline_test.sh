#!/bin/sh


echo "starting..."

module load python/conda-python

source activate /home/priyanka/Priya/metagenomics/metaEnv


## Host contamination removal
date
echo "Host contamination removal started"

read1=../R1.fastq.gz
read2=../R2.fastq.gz

bowtie2 -x /home/priyanka/Priya/metagenomics/GRCh38_noalt_as/GRCh38_noalt_as \
-1 /home/priyanka/Priya/metagenomics/rawReads/$read1 \
-2 /home/priyanka/Priya/metagenomics/rawReads/$read2 \
--un-conc-gz \
/home/priyanka/Priya/metagenomics/sample1host_removed \
> /home/priyanka/Priya/metagenomics/sample1map_unmapped.sam

echo " host removal completed.. "

mv sample1host_removed.1 sample1host_removed_R1.fastq.gz
mv sample1host_removed.2 sample1host_removed_R2.fastq.gz 

# echo " renamed sample_host_removed.[num] to sample_host_removed_[num].fastq.gz "

## assembly

echo "assembly started.."
date

metaspades.py -k 33,55,99 \
-1 /home/priyanka/Priya/metagenomics/sample1host_removed_R1.fastq.gz \
-2 /home/priyanka/Priya/metagenomics/sample1host_removed_R2.fastq.gz \
-o /home/priyanka/Priya/metagenomics/sample1spades_output

echo "finished assembly..."

echo "index building"
date

bowtie2-build /home/priyanka/Priya/metagenomics/sample1spades_output/contigs.fasta \
/home/priyanka/Priya/metagenomics/sample1spades_output/final.contigs


bowtie2 -x /home/priyanka/Priya/metagenomics/sample1spades_output/final.contigs \
-1 /home/priyanka/Priya/metagenomics/rawReads/$read1 \
-2 /home/priyanka/Priya/metagenomics/rawReads/$read2 | \
    samtools view -bS -o ./sample1sort.bam

date
samtools sort ./sample1sort.bam -o ./sample1.bam
samtools index ./sample1.bam

## binning
echo "started binning..."
date

run_MaxBin.pl -contig /home/priyanka/Priya/metagenomics/sample1spades_output/contigs.fasta \
-reads /home/priyanka/Priya/metagenomics/sample1host_removed_R1.fastq.gz \
-reads2 /home/priyanka/Priya/metagenomics/sample1host_removed_R2.fastq.gz \
-out sample1mbin

echo "finished binning"

## Taxonomic profiling
echo " taxonomic profiling"
date

kraken2 --db /home/priyanka/Priya/standard_db --use-names \
/home/priyanka/Priya/metagenomics/sample1mbin.*.fasta \
--report ./tax/sample1Evol.report --report-zero-counts \
--output ./tax/sample1Evol.out

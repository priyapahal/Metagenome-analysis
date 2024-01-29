 #!/bin/bash
 

#creating a new folder
mkdir fastqc_new

#finding files inside the current location based on the condition.
#these files are sent to FastQC to QC and saved in the new folder.
find . -type f -name "*.fastq.gz" | xargs fastqc -o fastqc_new

multiqc fastqc_new/ -o multiqc_result/
#stored stdout file names for further analysis.

java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE  -threads 10 -trimlog trim_log.log R1.fastq.gz R2.fastq.gz trim_out/R1_forwardPaired.fastq.gz trim_out/R1.forwardUnpaired.fastq.gz trim_out/R2.backwardPaired.fastq.gz trim_out/R2.backward_unpaired.fastq.gz ILLUMINACLIP:"Trimmomatic-0.39/adapters/NexteraPE-PE.fa":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:32
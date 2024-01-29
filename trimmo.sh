 #!/bin/bash
 
 
<<param

trim_cmd="java -jar ./../Trimmomatic-0.39/trimmomatic-0.39.jar"
paired="PE"
threads="-threads 10"
logging="-trimlog trim_log.log"
r1_file="./../R1.fastq.gz"
r2_file="./../R2.fastq.gz"
r1_fwd_paired="./../trim_out/R1_forwardPaired1.fastq.gz"
r1_fwd_unpaired="./../trim_out/R1.forwardUnpaired1.fastq.gz" 
r2_rev_paired="./../trim_out/R2.backwardPaired1.fastq.gz"
r2_rev_unpaired="./../trim_out/R2.backward_unpaired1.fastq.gz"
adapter="ILLUMINACLIP:"./../Trimmomatic-0.39/adapters/NexteraPE-PE.fa":2:30:10" 
leading="LEADING:3"
trailing="TRAILING:3"
sliding_window="SLIDINGWINDOW:4:15"
min_len="MINLEN:32"


execution_cmd=$(eval "$trim_cmd $paired $thread $logging $r1_file $r2_file $r1_fwd_paired $r1_fwd_unpaired $r2_rev_paired $r2_rev_unpaired $adapter $leading $trailing $sliding_window $min_len")

echo "$execution_cmd"

param


base_dir="./rawReads"
subdirs=$(find "${base_dir}" -type d)

for subdir in ${subdirs}; do
	mkdir -p "./trimmed"		
	if [ "${subdir}" != "${base_dir}" ]; then
		
		echo " Processing : ${subdir}"
		mkdir -p "./trimmed/${subdir}"
		#<<com
		for file in "${subdir}"/*fastq.gz; do
			
			#echo " Processing file : ${file}"
			
			if [[ ${file} == *"R1"* ]]
			then
				r1=$(basename "${file}" .fastq.gz)
				echo $r1
				#return $r1
				
			elif [[ ${file} == *"R2"* ]];
			then
				r2=$(basename "${file}" .fastq.gz)
				echo $r2
				#return $r2
			else
				#echo "no files found in ${file}"
				continue
			fi
			 
		done
		echo "${r1}.fastq.gz ${r2}.fastq.gz ${r1}_paired.fastq.gz ${r1}_unpaired.fastq.gz ${r2}_paired.fastq.gz ${r2}_unpaired.fastq.gz"
		#com
	fi
done

#echo $(eval wc "$r1")
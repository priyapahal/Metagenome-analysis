#!/bin/bash


base_dir="./rawReads"

trimmomatic_path="./Trimmomatic-0.39/trimmomatic-0.39.jar"


trimmomatic_param="ILLUMINACLIP:"./Trimmomatic-0.39/adapters/NexteraPE-PE.fa":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"


process_folder(){

	local folder="$1"
	#mkdir trimmed
	trimmed_folder="./trimmed"
	
	mkdir -p "${trimmed_folder}"
	
	for file in "${folder}"/*fastq.gz; do
		echo "Processing file: $(file)"
		
		filename=$(basename "${file}".fastq.gz)
		
		
		output_file_1="${trimmed_folder}/${filename}_trimmed_R1.fastq.gz"
		output_file_2="${trimmed_folder}/${filename}_trimmed_R2.fastq.gz"
		
		java -jar "${trimmomatic_path}" PE -phred33 "${file}" "${folder}/${filename}_R2.fastq.gz" \
		"${output_file_R1}" "${output_file_R1}_unpaired.fastq.gz" \
		"${output_file_R2}" "${output_file_R2}_unpaired.fastq.gz" \
		${trimmomatic_params}
		
	done
}

subdirs=$(find "${base_dir}" -type d)

for subdir in ${subdirs}; do
	if [ "${subdir}" != "${base_dir}" ]; then
		process_folder "${subdir}"
	fi
done

echo $base_dir
echo $trimmomatic_path
echo $trimmomatic_param
echo "Processing done."ss
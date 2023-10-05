#!/usr/bin/env nextflow


     // Define a channel to pass input data (if needed)
    inputFile = Channel.fromPath("00_INPUT/in.vcf")
	
	// Define the volume to mount into the container
    dataVolume = "~/snpEff/PIPE/00_INPUT/"

    
    // Define a process to run inside the Singularity container
    process singularityProcess {
        
        // Define the input data (if needed)
        input:
        path $inputFile
        
        // Define the command to be executed inside the container
        script:
        """
        #!/bin/bash
	singularity exec -B ${dataVolume}:/input snpEff:5.0.sif
	echo "test"
	ls -l /input
        java -jar /usr/local/share/snpeff-5.0-0/snpEff.jar -i vcf -o vcf -fastaProt out.fa hg38 /input/in.vcf > out.vcf
        """
    }

workflow {
	singularityProcess(inputFile)
}

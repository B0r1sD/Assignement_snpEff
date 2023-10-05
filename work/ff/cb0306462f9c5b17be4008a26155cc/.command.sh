#!/bin/bash
singularity exec -B DataflowBroadcast around DataflowStream[?]:/input snpEff:5.0.sif
       java -jar /usr/local/share/snpeff-5.0-0/snpEff.jar -i vcf -o vcf -fastaProt out.fa hg38 /input/in.vcf > out.vcf

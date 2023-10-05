#!/bin/bash -ue
cd /home/guest/snpEff/PIPE
java -jar /usr/local/share/snpeff-5.0-0/snpEff.jar -i vcf -o vcf -fastaProt out.fa ~/snpEff/data/hg38 00_INPUT/in.vcf

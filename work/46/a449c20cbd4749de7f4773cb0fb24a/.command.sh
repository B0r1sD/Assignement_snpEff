#!/bin/bash -ue
java -jar /usr/local/share/snpeff-5.0-0/snpEff.jar -i vcf -o vcf -fastaProt out.fa 00_INPUT/in.vcf > out.vcf

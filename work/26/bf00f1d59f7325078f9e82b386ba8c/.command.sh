#!/bin/bash -ue
java -jar snpEff.jar -i vcf -o vcf -fastaProt out.fa hg38 00_INPUT/in.vcf > out.vcf

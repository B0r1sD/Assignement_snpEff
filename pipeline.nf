#!/usr/bin/env nextflow
 
// input file
// params.in = "$baseDir/00_INPUT/in.vcf"
params.in = file("$baseDir/00_INPUT/in.vcf")
 
// define process
process snpEff {
 
    input:
    path 'in.vcf'
 
    output:
    path 'out.vcf'
 
    """
    cd $baseDir
    java -jar /usr/local/share/snpeff-5.0-0/snpEff.jar -i vcf -o vcf -fastaProt out.fa ~/snpEff/data/hg38 00_INPUT/in.vcf
    """
}
 
 
/*
 * Define workflow that executes process
 */
workflow {
    snpEff(params.in) \
      | view
}

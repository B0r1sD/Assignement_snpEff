# Assignement_snpEff
Containerized, Modular Nextflow pipeline (steps 2 out of 12) using locally installed tools or runnable on a Linux compute cluster (through Singularity)

**Additional info**  
Singularity: https://elearning.vib.be/courses/introduction-to-docker/lessons/  
Nextflow: https://vibbits-nextflow-workshop.readthedocs.io/en/latest/nextflow/
 
## learning previous method from masterscript.pl
### Part 1: snpEff

Here, the program snpEff is ran using the singularity image file (.sif) found on the wiki README.md

Download Singularity image from SnpEff 5.0 (version 2020-08-09): `singularity pull --name snpEff:5.0.sif https://depot.galaxyproject.org/singularity/snpeff%3A5.0--0`

The command to run on the vcf.in file: `java -jar $SNPEFFJAR -i vcf -o vcf -fastaProt out.fa hg38 /input/in.vcf > out.vcf`
with $SNPEFFJAR = "/usr/local/share/snpeff-5.0-0/snpEff.jar"

Download hg38 database locally via `java -jar /path/to/snpEff.jar download GRCh38.76` -> This database is required in the Signularity container and should be mounted (found in snpEff/data/hg38).


This outputs the files: out.vcf out.fa snpEff_genes.txt (SnpEff_errors.txt)

```
SNPEFF: # add extra annotation to VCF file and generate fastA file
open SCRIPT, '>SnpEffscript.sh';
  print SCRIPT "java -jar $SnpEffjar -i vcf -o vcf -fastaProt out.fa $SnpEffgenome in.vcf > out.vcf\n";
close SCRIPT;
if (system "qsub -cwd -sync y -l mem_limit=$JAVAMEM SnpEffscript.sh") {
  die "problem with step SNPEFF\n";
}
$WARNING = `grep WARNING_REF_DOES_NOT_MATCH_GENOME out.vcf | head`;
if ($WARNING) {
  die "$WARNING...\nout.vcf contains lines with WARNING_REF_DOES_NOT_MATCH_GENOME\nAre you sure the reads were mapped to $SnpEffgenome ?\n";
}
system "mv SnpEffscript.sh.e* SnpEff_errors.txt";
unlink 'SnpEffscript.sh';
unlink 'snpEff_summary.html'; # IF NEEDED OUTCOMMENT
# workflow output : out.vcf out.fa snpEff_genes.txt SnpEff_errors.txt
```

### Part 2: ParseSnpEff

Here, the Perl parsing script is ran on output from step 1.

`parseSnpEfffasta.pl $MAXLEN
with $MAXLEN a parameter that is passed to the parseSnpEfffasta.pl script:
$MAXLEN = 10000

```
PARSESNPEFF: # parse out.fa to find SNP's that cause aa substitution
if (system "qsub -cwd -b y -sync y -l mem_limit=$MEM $scriptdir/parseSnpEfffasta.pl $MAXLEN $SwissProtstandard") {
  die "problem with step PARSESNPEFF parseSnpEfffasta.pl\n";
}
system 'sort -n -k 1 sequence_identities_unsorted.tab > sequence_identities.tab';
if (system "qsub -cwd -b y -sync y -l mem_limit=$MEM $scriptdir/parseVCF.pl") {
  die "problem with step PARSESNPEFF parseVCF.pl\n";
}
unlink 'sequence_identities_unsorted.tab';
unlink 'out.fa'; # IF NEEDED OUTCOMMENT
unlink 'out.vcf'; # IF NEEDED OUTCOMMENT
# workflow output :
#   variants.tab reference_sequences.fa mutated_sequences.fa
#   reference_sequences_nonredundant.fa sequence_identities.tab
#   SNPAAchange.vcf variants_not_investigated.txt
```

## Setting up the Nextflow script

A Nextflow workflow that executes the snpEff command while having access to in.vcf and hg38 database and outputting all files correctly. Second is executing a Perl script on aforementioned output to parse the vcf file.

As I don't have access to the snpEff Singularity image, I'll have to install Perl inbetween the two steps in the container. 

Considerations when making pipeline:
* Using the available resources optimally
* Versions of the tools being used
* Working locally and on HPC env (cfr. installation of tools)
* Pipeline failing somewhere in the middle, not needing to restart pipeline from the beginning

Command `nextflow run pipeline.nf -with-singularity ~/snpEff/snpEff\:5.0.sif` (WIP)

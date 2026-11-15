#!/bin/bash
#SBATCH --job-name=Filter_GFF
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/Filter_GFF/Filter_GFF_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/Filter_GFF/Filter_GFF_%j.err

set -euo pipefail

COURSEDIR="/data/courses/genome_annotation_resources/2026"
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
OUTDIR="$WORKDIR/output/MAKER"
FINALDIR="$OUTDIR/final"
MAKER_SIF="$COURSEDIR/containers/MAKER_3.01.03.sif"
ANALYSIS_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"

gff="assembly.all.maker.noseq.gff"
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"

cd "$FINALDIR"

# Filter the GFF file based on the AED values and/or functional annotations from InterProScan.
apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" \
    --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$MAKER_SIF" perl /usr/local/bin/quality_filter.pl \
    -s ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff
# In the above command: -s Prints transcripts with an AED <1 and/or Pfam domain if in gff3


# Filter the GFF File for Gene Features

# We only want to keep gene features and subfeatures in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" \
    ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
sed -i '1i##gff-version 3' filtered.genes.renamed.gff3
# Check
cut -f3 filtered.genes.renamed.gff3 | sort | uniq


# Extract the list of remaining mRNA IDs from the filtered GFF3 file, and use this list to filter the transcript and protein FASTA files
grep -P "\tmRNA\t" filtered.genes.renamed.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' > list.txt

apptainer exec --cleanenv --bind "$COURSEDIR" \
    --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$ANALYSIS_SIF" seqkit grep \
    -f list.txt ${transcript}.renamed.fasta -o ${transcript}.renamed.filtered.fasta
apptainer exec --cleanenv --bind "$COURSEDIR" \
    --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$ANALYSIS_SIF" seqkit grep \
    -f list.txt ${protein}.renamed.fasta -o ${protein}.renamed.filtered.fasta
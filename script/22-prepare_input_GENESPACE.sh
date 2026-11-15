#!/bin/bash
#SBATCH --job-name=prepare_input_GeneSpace
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=03:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-11-04
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/prepare_input_GeneSpace/prepare_input_GeneSpace%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/prepare_input_GeneSpace/prepare_input_GeneSpace%j.err
set -euo pipefail

Accession=Hiroshima
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
COURSEDIR="/data/courses/genome_annotation_resources/2026"
FINALDIR="$WORKDIR/output/MAKER/final"
GENES="$FINALDIR/filtered.genes.renamed.gff3"
OUTDIR="$WORKDIR/output/comparisons"
GENESPACE_DIR="$OUTDIR/GENESPACE"

mkdir -p "$GENESPACE_DIR/bed" "$GENESPACE_DIR/peptide" "$GENESPACE_DIR/tmp"

grep -P "\tgene\t" "$GENES" > "$GENESPACE_DIR/temp_genes.gff3"

# Prepare your accession

# Get the the first attribute in column 9 which is ID=gene_name.
awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' \
    "$GENESPACE_DIR/temp_genes.gff3" > "$GENESPACE_DIR/bed/${Accession}.bed"

# longest-protein FASTA
LONGEST_PROTEINS="$FINALDIR/assembly.all.maker.proteins.fasta.renamed.longest.fasta"
# Remove transcript suffixes and descriptions from FASTA headers.
sed '/^>/s/ .*//' "$LONGEST_PROTEINS" | sed '/^>/s/-R[A-Z]*$//' \
    > "$GENESPACE_DIR/peptide/${Accession}.fa"

#ADD TAIR10
cp "$COURSEDIR/data/TAIR10.bed" "$GENESPACE_DIR/bed/TAIR10.bed"
cp "$COURSEDIR/data/TAIR10.fa" "$GENESPACE_DIR/peptide/TAIR10.fa"

# Add three other accessions
other_1=Etna_2

cp "$COURSEDIR/data/Lian_et_al/GENESPACE/bed/${other_1}.bed" \
    "$GENESPACE_DIR/bed/${other_1}.bed"
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/peptide/${other_1}.fa" \
    "$GENESPACE_DIR/peptide/${other_1}.fa"


other_2=Altai_5

cp "$COURSEDIR/data/Lian_et_al/GENESPACE/bed/${other_2}.bed" \
    "$GENESPACE_DIR/bed/${other_2}.bed"
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/peptide/${other_2}.fa" \
    "$GENESPACE_DIR/peptide/${other_2}.fa"

other_3=Taz_0

cp "$COURSEDIR/data/Lian_et_al/GENESPACE/bed/${other_3}.bed" \
    "$GENESPACE_DIR/bed/${other_3}.bed"
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/peptide/${other_3}.fa" \
    "$GENESPACE_DIR/peptide/${other_3}.fa"
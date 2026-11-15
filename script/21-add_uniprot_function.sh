#!/bin/bash
#SBATCH --job-name=add_uniprot_function
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=03:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-11-11
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/add_uniprot_function/add_uniprot_function%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/add_uniprot_function/add_uniprot_function%j.err
set -euo pipefail

WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
COURSEDIR="/data/courses/genome_annotation_resources/2026"
FINALDIR="$WORKDIR/output/MAKER/final"
PROTEINS="$FINALDIR/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
UNIPROT="$COURSEDIR/data/uniprot_renamed/uniprot_viridiplantae_reviewed.fa"
OUTDIR="$WORKDIR/output/comparisons"
MAKER_SIF="$COURSEDIR/containers/MAKER_3.01.03.sif"
GENES="$FINALDIR/filtered.genes.renamed.gff3"

mkdir -p "$OUTDIR/tmp"

apptainer exec --cleanenv --env TMPDIR=/tmp \
     --bind /data --bind "$WORKDIR" \
     --bind "$OUTDIR/tmp":/tmp \
     --pwd "$OUTDIR" "$MAKER_SIF" \
     maker_functional_fasta "$UNIPROT" "$OUTDIR/blastp_uniprot.besthits.tsv" "$PROTEINS" \
     > "$OUTDIR/maker_proteins.filtered.Uniprot.fasta"

apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind /data --bind "$WORKDIR" \
    --bind "$OUTDIR/tmp":/tmp \
    --pwd "$OUTDIR" "$MAKER_SIF" \
    maker_functional_gff "$UNIPROT" "$OUTDIR/blastp_uniprot.besthits.tsv" "$GENES" \
    > "$OUTDIR/filtered.genes.Uniprot.gff3"

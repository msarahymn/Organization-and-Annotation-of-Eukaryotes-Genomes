#!/bin/bash
#SBATCH --job-name=run_TEsorter
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/run_TEsorter/run_TEsorter_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/run_TEsorter/run_TEsorter_%j.err



set -euo pipefail
WORKDIR=/data/users/mmaisyaroh/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
INDIR=$WORKDIR/output/seqkit
OUTDIR=$WORKDIR/output/TEsorter

mkdir -p "$OUTDIR"
cd "$OUTDIR"

apptainer exec --bind "$WORKDIR" "/data/courses/genome_annotation_resources/2026/containers/TEsorter_1.3.0.sif" \
    TEsorter "$INDIR/Copia_sequences.fa" -db rexdb-plant -p 4

apptainer exec --bind "$WORKDIR" "/data/courses/genome_annotation_resources/2026/containers/TEsorter_1.3.0.sif" \
    TEsorter "$INDIR/Gypsy_sequences.fa" -db rexdb-plant -p 4
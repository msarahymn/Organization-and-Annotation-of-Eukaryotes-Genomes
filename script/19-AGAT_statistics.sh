#!/bin/bash
#SBATCH --job-name=AGAT_statistics
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=03:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/AGAT/AGAT_statistics%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/AGAT/AGAT_statistics%j.err


set -euo pipefail

COURSEDIR="/data/courses/genome_annotation_resources/2026"
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
FINALDIR="$WORKDIR/output/MAKER/final"

protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"

AGAT_SIF="$COURSEDIR/containers/AGAT_v1.4.1.sif"
apptainer exec --cleanenv --bind "$COURSEDIR" \
    --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$AGAT_SIF" \
    agat_sp_statistics.pl \
    --gff filtered.genes.renamed.gff3 \
    --output annotation.stat

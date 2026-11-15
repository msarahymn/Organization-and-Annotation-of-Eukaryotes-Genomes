#!/bin/bash
#SBATCH --job-name=samtool_faidx 
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=1 
#SBATCH --mem=32G 
#SBATCH --time=01:00:00 
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/samtools_faidx/samtools_faidx_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/samtools_faidx/samtools_faidx_%j.err

set -euo pipefail

COURSEDIR=/data/courses/genome_annotation_resources/2026
WORKDIR=/data/users/mmaisyaroh/genome_annotation_course
INPUT_FASTA=/data/users/mmaisyaroh/assembly_course/assemblies/flye/assembly.fasta
OUTDIR=$WORKDIR/output/samtools_faidx

# Create the output directory if it doesn't already exist:
mkdir -p "${OUTDIR}"


apptainer exec -C --bind /data/users/mmaisyaroh \
    "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
    samtools faidx $INPUT_FASTA --fai-idx "$OUTDIR/assembly.fasta.fai"

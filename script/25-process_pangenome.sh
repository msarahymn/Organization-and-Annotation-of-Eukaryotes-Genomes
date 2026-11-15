#!/bin/bash
#SBATCH --job-name=run_Pangenome
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
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/Pangenome/Pangenome%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/Pangenome/Pangenome%j.err

set -euo pipefail

WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
COURSEDIR="/data/courses/genome_annotation_resources/2026"
ANALYSIS_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"
TMPDIR="$WORKDIR/output/comparisons/Annotation_R_tmp"
mkdir -p "$TMPDIR"
apptainer exec --cleanenv \
    --bind /data --bind "$WORKDIR" \
    --bind "$TMPDIR":/temp --env TMPDIR=/temp --pwd "$WORKDIR" \
    "$ANALYSIS_SIF" Rscript "$WORKDIR/script/25-process_pangenome.R"
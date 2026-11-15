#!/bin/bash
#SBATCH --job-name=LTR_identity
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-14
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/LTR_identity_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/LTR_identity_%j.err

set -euo pipefail
WORKDIR=/data/users/mmaisyaroh/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/LTR_full_length
cd "$OUTDIR"

apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" --pwd "$OUTDIR" \
  "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
  Rscript --vanilla "$COURSEDIR/scripts/03-full_length_LTRs_identity.R"
#!/bin/bash
#SBATCH --job-name=TE_annotation_circlize
#SBATCH --partition=pshort_el8
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/TE_annotation_circlize_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/TE_annotation_circlize_%j.err

set -euo pipefail
WORKDIR=/data/users/mmaisyaroh/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/annotation_circlize

mkdir -p "$OUTDIR"
cd "$OUTDIR"

apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" --pwd "$OUTDIR" \
  "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
  Rscript --vanilla "$WORKDIR/script/05-annotation_circlize.R"
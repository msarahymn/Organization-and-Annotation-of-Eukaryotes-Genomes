#!/bin/bash
#SBATCH --job-name=TE_landscape_plot_div
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/TE_landscape_plot_div/TE_landscape_plot_div_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/TE_landscape_plot_div/TE_landscape_plot_div_%j.err

set -euo pipefail
WORKDIR=/data/users/mmaisyaroh/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/TE_landscape_plot_div

mkdir -p "$OUTDIR"
cd "$OUTDIR"

apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" --pwd "$OUTDIR" \
  "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
  Rscript --vanilla "$WORKDIR/script/09-plot_div.R"
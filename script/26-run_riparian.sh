#!/bin/bash
#SBATCH --job-name=riparian
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-11-11
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/Riparian/Riparian%j.out
#SBATCH --error=`/data/users/mmaisyaroh/genome_annotation_course/logs/Riparian/Riparian%j.err


set -euo pipefail
WORKDIR=/data/users/mmaisyaroh/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
GENESPACE_SIF="$COURSEDIR/containers/genespace_latest.sif"

TMPDIR="$WORKDIR/output/comparisons/GENESPACE_R_tmp"
mkdir -p "$TMPDIR"
cd "$WORKDIR"

apptainer exec --cleanenv \
  --bind /data --bind "$WORKDIR" \
  --bind "$TMPDIR":/temp --env TMPDIR=/temp --pwd "$WORKDIR" \
  "$GENESPACE_SIF" Rscript "$WORKDIR/script/26-riparian_visualize_synteny.R"
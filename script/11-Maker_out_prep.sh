#!/bin/bash
#SBATCH --job-name=Maker_output_prep
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/Maker/Maker_out_prep_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/Maker/Maker_out_prep_%j.err

set -euo pipefail

COURSEDIR="/data/courses/genome_annotation_resources/2026"
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
OUTDIR="$WORKDIR/output/MAKER"
MAKER_SIF="$COURSEDIR/containers/MAKER_3.01.03.sif"

mkdir -p "$OUTDIR/tmp"
cd "$OUTDIR"
shopt -s nullglob
INDEXES=(*.maker.output/*master_datastore_index.log)
test "${#INDEXES[@]}" -eq 1
INDEX="${INDEXES[0]}"

apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" --pwd "$OUTDIR" "$MAKER_SIF" \
    gff3_merge -d "$INDEX" -o assembly.all.maker.gff
apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" --pwd "$OUTDIR" "$MAKER_SIF" \
    gff3_merge -n -d "$INDEX" -o assembly.all.maker.noseq.gff
apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" --pwd "$OUTDIR" "$MAKER_SIF" \
    fasta_merge -d "$INDEX" -o assembly
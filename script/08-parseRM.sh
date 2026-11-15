#!/bin/bash
#SBATCH --job-name=parseRM
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/parseRM/parseRM_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/parseRM/parseRM_%j.err


set -euo pipefail
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
COURSEDIR="/data/courses/genome_annotation_resources/2026"
INDIR="$WORKDIR/output/EDTA/assembly.fasta.mod.EDTA.anno"
OUTDIR="$WORKDIR/output/parseRM"
PARSERM_SCRIPT="${WORKDIR}/script/08-parseRM.pl"

mkdir -p $OUTDIR
cd "$OUTDIR"

# Step 1: remove hits with 0% divergence
awk 'NR == 1 || $2 != 0' "$INDIR/assembly.fasta.mod.EDTA.RM.out" > "$OUTDIR/assembly.fasta.mod.EDTA.RM.nonzero.out"


# Step 2: bin divergence into 1% bins (up to 50%) per TE superfamily
apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" \
    "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
    perl "$PARSERM_SCRIPT" \
    -i "$OUTDIR/assembly.fasta.mod.EDTA.RM.nonzero.out" \
    -l 50,1 -v


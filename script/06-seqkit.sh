#!/bin/bash
#SBATCH --job-name=seqkit 
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/seqkit_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/seqkit_%j.err

# Extract Copia and Gypsy Sequence

set -euo pipefail
WORKDIR=/data/users/mmaisyaroh/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/seqkit
TElib=${WORKDIR}/output/EDTA/assembly.fasta.mod.EDTA.TElib.fa


# Create the output directory if it doesn't already exist:
mkdir -p "${OUTDIR}"



# Extract Copia sequences
apptainer exec -C --bind "$WORKDIR" "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
    seqkit grep -r -p "Copia" "$TElib" > "$OUTDIR/Copia_sequences.fa"

# Extract Gypsy sequences
apptainer exec -C --bind "$WORKDIR" "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
    seqkit grep -r -p "Gypsy" "$TElib" > "$OUTDIR/Gypsy_sequences.fa"
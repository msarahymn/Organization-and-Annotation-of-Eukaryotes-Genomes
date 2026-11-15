#!/bin/bash
#SBATCH --job-name=Maker_RenameGene
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
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/Maker_RenameGene/Maker_RenameGene_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/Maker_RenameGene/Maker_RenameGene_%j.err

set -euo pipefail

COURSEDIR="/data/courses/genome_annotation_resources/2026"
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
OUTDIR="$WORKDIR/output/MAKER"
FINALDIR="$OUTDIR/final"
MAKER_SIF="$COURSEDIR/containers/MAKER_3.01.03.sif"

# Copy the three merged annotation files into $OUTDIR/final, using new filenames for ID renaming
mkdir -p "$FINALDIR/tmp"
cd "$OUTDIR"


protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"

cp "$OUTDIR/$gff" "$FINALDIR/${gff}.renamed.gff"
cp "$OUTDIR/$protein" "$FINALDIR/${protein}.renamed.fasta"
cp "$OUTDIR/$transcript" "$FINALDIR/${transcript}.renamed.fasta"
cd "$FINALDIR"

prefix=Hiroshima              #-->  accession prefix/short name.
#1). Build clean ID
apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$MAKER_SIF" maker_map_ids \
    --prefix $prefix --justify 7 ${gff}.renamed.gff > id.map

#2). Apply new id to GFF
apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$MAKER_SIF" map_gff_ids id.map ${gff}.renamed.gff

#3). Apply new id to protein
apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$MAKER_SIF" map_fasta_ids id.map ${protein}.renamed.fasta

#4). Apply new id to transcript
apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$FINALDIR" "$MAKER_SIF" map_fasta_ids id.map ${transcript}.renamed.fasta
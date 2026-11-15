#!/bin/bash
#SBATCH --job-name=BUSCO
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=03:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/BUSCO/Busco%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/BUSCO/Busco%j.err


set -euo pipefail

COURSEDIR="/data/courses/genome_annotation_resources/2026"
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
OUTDIR="$WORKDIR/output/Busco"
FINALDIR="$WORKDIR/output/MAKER/final"

protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"

mkdir -p "$OUTDIR"
cd "$FINALDIR"

module load BUSCO/5.4.2-foss-2021a
export PYTHONNOUSERSITE=1

# Run BUSCO on the LONGEST protein and transcript sequences
busco -i "${protein}.renamed.longest.fasta" \
    -l brassicales_odb10 \
    -o busco_proteins \
    --out_path "$OUTDIR" \
    -m proteins \
    -c 4


busco -i "${transcript}.renamed.longest.fasta" \
    -l brassicales_odb10 \
    -o busco_transcripts \
    --out_path "$OUTDIR" \
    -m transcriptome \
    -c 4

#Plot the Busco
# generate_plot.py reads every short_summary*.txt
# copy both summaries into one folder 
mkdir -p "$OUTDIR/plot"
cp "$OUTDIR"/busco_proteins/short_summary*.txt    "$OUTDIR/plot/"
cp "$OUTDIR"/busco_transcripts/short_summary*.txt "$OUTDIR/plot/"

generate_plot.py -wd "$OUTDIR/plot"

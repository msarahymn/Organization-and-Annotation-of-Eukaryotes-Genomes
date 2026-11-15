#!/bin/bash
#SBATCH --job-name=InterProScan
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/InterProScan/InterProScan_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/InterProScan/InterProScan_%j.err



COURSEDIR="/data/courses/genome_annotation_resources/2026"
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
OUTDIR="$WORKDIR/output/MAKER"
FINALDIR="$OUTDIR/final"
INTERPROSCAN_SIF="$COURSEDIR/containers/InterProScan_5.70.sif"
protein="assembly.all.maker.proteins.fasta"

apptainer exec --cleanenv --pwd "$FINALDIR" \
    --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
    --bind "$COURSEDIR" --bind "$WORKDIR" \
    --bind "$FINALDIR/tmp":/temp \
    "$INTERPROSCAN_SIF" \
    /opt/interproscan/interproscan.sh \
    -appl pfam \
    --disable-precalc \
    -f TSV \
    --goterms \
    --iprlookup \
    --seqtype p \
    -i ${protein}.renamed.fasta -o output.iprscan


# Option meanings:
#   -appl pfam        : search only the Pfam database (protein domain families)
#   --disable-precalc : don't use EBI's online precomputed results; compute everything locally
#   -f TSV            : output format = tab-separated table (one line per domain hit)
#   --goterms         : add Gene Ontology (GO) terms linked to each domain
#   --iprlookup       : add the InterPro entry (IPRxxxxxx) linked to each Pfam hit
#   --seqtype p       : input sequences are proteins
#   -i / -o           : input FASTA / output file name
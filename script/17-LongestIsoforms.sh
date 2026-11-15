#!/bin/bash
#SBATCH --job-name=Longest_isoform
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=00:30:00
#SBATCH --mail-user=maisyaroh.maisyaroh@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28
#SBATCH --output=/data/users/mmaisyaroh/genome_annotation_course/logs/BUSCO/Longest_%j.out
#SBATCH --error=/data/users/mmaisyaroh/genome_annotation_course/logs/BUSCO/Longest_%j.err

set -euo pipefail

# Tools: samtools (sequence lengths), faSomeRecords (extract records by ID)
module load SAMtools/1.13-GCC-10.3.0
module load UCSC-Utils/448-foss-2021a
module load MariaDB/10.6.4-GCC-10.3.0     # needed by the UCSC tools

# --- Paths ---
WORKDIR="/data/users/mmaisyaroh/genome_annotation_course"
FINALDIR="$WORKDIR/output/MAKER/final"
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"

cd "$FINALDIR"

# Do the same for proteins and transcripts
for fa in "$protein" "$transcript"; do
    IN="${fa}.renamed.filtered.fasta"     # input: quality-filtered sequences (all isoforms)
    OUT="${fa}.renamed.longest.fasta"     # output: 1 longest isoform per gene (for BUSCO)
    IDS="${fa}.longest_ids.txt"           # list of the chosen IDs

    # 1) Index the FASTA -> IN.fai, column 1 = ID, column 2 = length
    samtools faidx "$IN"

    # 2) Choose the longest isoform per gene
    #    - add gene name (ID before "-R"): gene  length  ID
    #    - sort by gene, then length from largest to smallest
    #    - keep only the first (= longest) line per gene, print its ID
    cut -f1,2 "${IN}.fai" \
    | awk 'BEGIN{FS=OFS="\t"} {split($1, a, "-R"); print a[1], $2, $1}' \
    | sort -t $'\t' -k1,1 -k2,2nr \
    | awk -F'\t' '!seen[$1]++ {print $3}' \
    > "$IDS"

    # 3) Extract only those records from the FASTA
    faSomeRecords "$IN" "$IDS" "$OUT"
done

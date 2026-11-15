library(GENESPACE)
wd <-"/data/users/mmaisyaroh/genome_annotation_course/output/comparisons/GENESPACE"
focal_genome <-"Hiroshima"
load(file.path(wd,"results","gsParams.rda")) # Loads gsParam.
dir.create(file.path(wd,"processed_riparian"), showWarnings = FALSE)

#compare with TAIR10
plot_riparian(gsParam,genomeIDs = c("TAIR10", focal_genome),
refGenome ="TAIR10",
reorderBySynteny = TRUE, pdfFile = file.path(wd,"processed_riparian","my_accession_vs_TAIR10.pdf")
)

# Improve scaffold order and display orientation
flips <- data.frame(genome = focal_genome, chr =c("contig_18", "contig_13", "contig_65", "contig_28", "contig_11",
                            "contig_23", "contig_14", "contig_99", "contig_73", "contig_26", "contig_1", "contig_38"))
plot_riparian(gsParam, genomeIDs = c("TAIR10", focal_genome), 
    refGenome ="TAIR10",
    reorderBySynteny = TRUE,
    syntenyWeight = 1,
    invertTheseChrs = flips,
    pdfFile = file.path(wd, "processed_riparian", "my_accession_vs_TAIR10_oriented.pdf")
)

#show all 5 genome
plot_riparian(gsParam, refGenome ="TAIR10",
    reorderBySynteny = TRUE,
    syntenyWeight = 1,
    invertTheseChrs = flips,
    scalePlotWidth = 1.5,
    pdfFile = file.path(wd, "processed_riparian", "all_genomes_TAIR10.pdf")
)
library(rtracklayer)
library(GenomicFeatures)
library(GenomicRanges)

# Read in the BED file
bed_gr <- import("E:/Logan_Blair/Synteny_analysis/DN_synteny/final_dn_transcript_regions_sorted.bed", format = "bed")
bed_gr <- import("E:/Logan_Blair/Synteny_analysis/UA_synteny/final_UA_transcript_regions_sorted.bed", format = "bed")

# Read in the GFF file
gtf <- import("E:/Logan_Blair/Synteny_analysis/DN_synteny/dmel-all-r6.41.gtf.gz", format = "gtf")

# Make a TxDb object from the GFF file
txdb <- makeTxDbFromGRanges(gtf)

# Filter GTF to only keep introns
introns <- intronicParts(txdb)
introns

# intergenic regions (i.e, genomic regions that do not overlap 
# with any features in the GTF file:

# Initialize a vector to store results
bed_regions <- character(length(bed_gr))

# Check if each BED feature is in an intronic region
for (i in seq_along(bed_gr)) {
  inside_introns <- findOverlaps(bed_gr[i], introns, type="within")
  inside_intergenes <- findOverlaps(bed_gr[i], gtf)
  if (length(inside_introns) > 0) {
    bed_regions[i] <- "intronic"
  } else if(length(inside_intergenes) == 0) {
    bed_regions[i] <- "intergenic"
  } else{
    bed_regions[i] <- "undetermined"
  }

}

bed_gr$region <- bed_regions
table(bed_regions)


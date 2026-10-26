# To estimate a maximum-likelihood phylogenetic tree based on mitogenome sequences

# Steps:

1. Extract mapped and unmapped reads from .bam files: `extract_bam_reads.sh`

2. Map to reads to the reference mitogenome: `align_bam_mito.sh`

3. Call variants and make a consensus sequence: `mitogenotype.sh`

4. Align consensus sequences and build a tree: `mitogenome_bam_IQtree.sh`

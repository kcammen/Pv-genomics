
#Extract genes from gff3 annotation file
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.gff3 | awk '$3 == "gene"' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt

#Extract gene notes ("Note=Protein of unknown function" or "Note=Similar to GENEID: Gene description (Genus Species ref #)")
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt | cut -f9- | awk -F "[;]" '{ print $4 }' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.note.txt

#Extract gene ID (Phoca_######)
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt | cut -f9- | awk -F "[;]" '{ print $1 }' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.ID.txt

cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt | awk '{ print $1 }' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.scaffold.txt
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt | awk '{ print $4 }' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.start.txt
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt | awk '{ print $5 }' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.end.txt
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt | awk '{ print $7 }' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.strand.txt
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.txt | awk '{ print $8 }' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.frame.txt

#Combine desired columns
paste GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.ID.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.scaffold.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.start.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.end.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.strand.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.frame.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.note.txt > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.txt

#Count number of genes = 34,325
wc -l GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.txt
#Extract putative gene symbol
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.txt | awk -F $'\t' '{print $7}' | awk '{print substr($3, 1, length($3)-1)}' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbol.txt
#append it to existing table
paste GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbol.txt > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbolTable.txt
#re-arrange columns to keep "note" as the last column
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbolTable.txt | awk -F $'\t' '{print $1,$2,$3,$4,$5,$6,$8,$7}' OFS='\t' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbolTable2.txt
#subset to include only autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbolTable2.txt > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbolTable2.autochr.txt
#Count number of genes = 34,325
wc -l GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.geneSymbolTable2.autochr.txt

#Remove "Protein of unknown function"
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.txt | awk -F $'\t' '$7!="Note=Protein of unknown function"' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.txt 
#Count number of genes with putatively assigned function = 24,221
wc -l GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.txt

#Extract putative gene symbol
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.txt | awk -F $'\t' '{print $7}' | awk '{print substr($3, 1, length($3)-1)}' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbol.txt
#append it to existing table
paste GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbol.txt > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable.txt
#re-arrange columns to keep "note" as the last column
cat GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable.txt | awk -F $'\t' '{print $1,$2,$3,$4,$5,$6,$8,$7}' OFS='\t' > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt
#subset to include only autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.autochr.txt



#1. Pathogen Recognition 
#1.a. PRR
#1.a.i. TLRs
awk '/Toll-like receptor/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > PRR.TLR.gene.list.txt #10 genes
wc -l PRR.TLR.gene.list.txt #10 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt PRR.TLR.gene.list.txt > PRR.TLR.gene.list.subset.txt 
wc -l PRR.TLR.gene.list.subset.txt #8 genes


#1.a.ii. RLRs
awk '/DDX58/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > PRR.RLR.gene.list.txt #1 gene
awk '/IFIH1/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.RLR.gene.list.txt #1 gene
awk '/DHX58/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.RLR.gene.list.txt #1 gene
wc -l PRR.RLR.gene.list.txt #3 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt PRR.RLR.gene.list.txt > PRR.RLR.gene.list.subset.txt
wc -l PRR.RLR.gene.list.subset.txt #3 genes

#1.a.iii. NLRs
awk '/NOD1/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > PRR.NLR.gene.list.txt #1 gene
awk '/NOD2/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.NLR.gene.list.txt #1 gene
awk '/NLRP1:/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.NLR.gene.list.txt #0 genes
awk '/NLRP3/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.NLR.gene.list.txt #2 genes
awk '/NLRC4/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.NLR.gene.list.txt #0 genes
wc -l PRR.NLR.gene.list.txt #4 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt PRR.NLR.gene.list.txt > PRR.NLR.gene.list.subset.txt
wc -l PRR.NLR.gene.list.subset.txt #3 genes

#1.a.iv. Cytosolic DNA sensors
awk '/CGAS/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > PRR.DNA.gene.list.txt #1 gene
awk '/TMEM173/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.DNA.gene.list.txt #1 gene
awk '/ AIM2:/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.DNA.gene.list.txt #1 gene
awk '/DDX60/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.DNA.gene.list.txt #2 genes
wc -l PRR.DNA.gene.list.txt #5 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt PRR.DNA.gene.list.txt > PRR.DNA.gene.list.subset.txt
wc -l PRR.DNA.gene.list.subset.txt #5 genes

#1.a.v. CLRs
awk '/MRC1/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > PRR.CLR.gene.list.txt #1 gene
awk '/MRC2/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.CLR.gene.list.txt #1 more gene
awk '/CLEC7A/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> PRR.CLR.gene.list.txt #1 more gene
wc -l PRR.CLR.gene.list.txt #3 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt PRR.CLR.gene.list.txt > PRR.CLR.gene.list.subset.txt
wc -l PRR.CLR.gene.list.subset.txt #3 genes

#1.b. TCR
awk '/T cell receptor alpha/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > TCR.gene.list.txt #17 genes
awk '/T cell receptor beta/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> TCR.gene.list.txt #5 genes
awk '/T cell receptor delta/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> TCR.gene.list.txt #3 genes
awk '/T cell receptor gamma/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> TCR.gene.list.txt #5 genes
awk '/CD247/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt #No genes found
awk '/T-cell surface glycoprotein CD3/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> TCR.gene.list.txt #3 genes
wc -l TCR.gene.list.txt #33 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt TCR.gene.list.txt > TCR.gene.list.subset.txt
wc -l TCR.gene.list.subset.txt #31 genes

#1.c. BCR
awk '/Immunoglobulin heavy/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > BCR.gene.list.txt #7 genes
awk '/Immunoglobulin lambda/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> BCR.gene.list.txt #18 genes
awk '/Immunoglobulin kappa/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> BCR.gene.list.txt #4 genes
awk '/CD79/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> BCR.gene.list.txt #2 genes
wc -l BCR.gene.list.txt #31 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt BCR.gene.list.txt > BCR.gene.list.subset.txt
wc -l BCR.gene.list.subset.txt #17 genes

cat PRR*gene.list.txt TCR.gene.list.txt BCR.gene.list.txt > PathogenRecognition.gene.list.txt
wc -l PathogenRecognition.gene.list.txt #89 genes
cat PRR*gene.list.subset.txt TCR.gene.list.subset.txt BCR.gene.list.subset.txt > PathogenRecognition.gene.list.subset.txt
wc -l PathogenRecognition.gene.list.subset.txt #70 genes

#2. Immune Signaling
#2.a. MHC
awk '/histocompatibility/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > MHC.gene.list.txt #17 genes
wc -l MHC.gene.list.txt #17 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt MHC.gene.list.txt > MHC.gene.list.subset.txt
wc -l MHC.gene.list.subset.txt #17 genes

#2.b. Cytokines
awk '/Interleukin/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > cytokines.gene.list.txt #83 genes
awk '/Interferon/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> cytokines.gene.list.txt #61 genes
awk '/TNF/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> cytokines.gene.list.txt #52 genes
awk '/colony-stimulating factor/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> cytokines.gene.list.txt #5 genes
awk '/chemokine/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> cytokines.gene.list.txt #47 genes
awk '/TGFB/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> cytokines.gene.list.txt #9 genes
wc -l cytokines.gene.list.txt #257 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt cytokines.gene.list.txt > cytokines.gene.list.subset.txt
wc -l cytokines.gene.list.subset.txt #247 genes

cat MHC.gene.list.txt cytokines.gene.list.txt > ImmuneSignaling.gene.list.txt
wc -l ImmuneSignaling.gene.list.txt #274 genes
cat MHC.gene.list.subset.txt cytokines.gene.list.subset.txt > ImmuneSignaling.gene.list.subset.txt
wc -l ImmuneSignaling.gene.list.subset.txt #264 genes

#3. Anti-pathogen effector response
#3.a. Interferons
awk '/Interferon/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > interferon.gene.list.txt #61 genes
wc -l interferon.gene.list.txt #61 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt interferon.gene.list.txt > interferon.gene.list.subset.txt
wc -l interferon.gene.list.subset.txt #59 genes

#3.b. Antimicrobial Peptides
awk '/Cathelicidin/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > AMP.gene.list.txt #1 result: CATHL7
awk '/defensin/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt >> AMP.gene.list.txt #26 genes
wc -l AMP.gene.list.txt #27 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt AMP.gene.list.txt > AMP.gene.list.subset.txt
wc -l AMP.gene.list.subset.txt #27 genes

cat interferon.gene.list.txt AMP.gene.list.txt > ImmuneEffector.gene.list.txt
wc -l ImmuneEffector.gene.list.txt #88 genes
cat interferon.gene.list.subset.txt AMP.gene.list.txt > ImmuneEffector.gene.list.subset.txt
wc -l ImmuneEffector.gene.list.subset.txt #86 genes

#4. Complement
awk '/Complement/' GSC_HSeal_1.0_HiC.fasta_v2.functional.genes.modtable.noUnknown.geneSymbolTable2.txt > Complement.gene.list.txt
wc -l Complement.gene.list.txt #43 genes
#exclude genes not found on autosomal chromosomes
awk 'NR==FNR {scaffolds[$1]; next} $2 in scaffolds' /path_to_project/ref/GSC_HSeal_1.0_HiC.autosomes.txt Complement.gene.list.txt > Complement.gene.list.subset.txt
wc -l Complement.gene.list.subset.txt #43 genes

cat PathogenRecognition.gene.list.txt ImmuneSignaling.gene.list.txt AMP.gene.list.txt Complement.gene.list.txt > CompleteImmune.gene.list.txt
wc -l CompleteImmune.gene.list.txt #433 genes (note that this does not include interferon list twice, despite it being in two of the four major categories)
cat PathogenRecognition.gene.list.subset.txt ImmuneSignaling.gene.list.subset.txt AMP.gene.list.subset.txt Complement.gene.list.subset.txt > CompleteImmune.gene.list.subset.txt
wc -l CompleteImmune.gene.list.subset.txt #404 genes (note that this does not include interferon list twice, despite it being in two of the four major categories)

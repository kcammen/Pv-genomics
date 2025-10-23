quiet <- function(x) { suppressMessages(suppressWarnings(x)) }
quiet(library(data.table))

quiet(library(optparse))
#--------------------------------------------------------------------------------
option_list = list(
    make_option(c("-h", "--highdepth"), type="character", default=NULL, help="high coverage results directory"),
    make_option(c("-l", "--lowdepth"), type="character", default=NULL, help="low coverage results directory"),
    make_option(c("-c", "--chr"), type="character", default=NULL, help="chromosome file"),
    make_option(c("-m", "--maxdepth"), type="character", default=NULL, help="maxdepth used in ANGSD"),
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

##----------------------------------------------------------------------------------------------
highDir <- opt$highdepth
lowDir <- opt$lowdepth

chrFile <- opt$chr
chrs <- scan(chrFile, what="dl")

maxdepth <- as.integer(opt$maxdepth)

#highDir <- "~/local_path_to_project/Depth/highDepth"
#lowDir <- "~/local_path_to_project/Depth/lowDepth"
#chrs <- scan("~/local_path_to_project/Depth/GSC_HSeal_1.0_HiC.autosomes.txt", what="dl")
#maxdepth <- 6000

tl <- numeric(maxdepth + 1)
th <- numeric(maxdepth + 1)

for(chr in chrs){

    lglobal <- scan(paste0(lowDir,"/",chr,"_lowDepth.depthGlobal"), what=3)
    hglobal <- scan(paste0(highDir,"/",chr,"_highDepth.depthGlobal"), what=3)

    #allglobal <- lglobal + hglobal

    tl <- tl + lglobal
    th <- th + hglobal
        
    #l <- fread(paste0(lowDir,"/",chr,"_lowDepth.pos.gz"))[,2:3]
    #h <- fread(paste0(highDir,"/",chr,"_highDepth.pos.gz"))[,2:3]

    #hl <- merge(l,h,by='pos',all=T)

    #hl$totDepth.x[is.na(hl$totDepth.x)] <- 0
    #hl$totDepth.y[is.na(hl$totDepth.y)] <- 0
    
}

write(tl, paste0(lowDir,"/autoChr_lowDepth.depthGlobal"), ncolumns=length(tl), sep="\t")
write(th, paste0(highDir,"/autoChr_highDepth.depthGlobal"), ncolumns=length(th), sep="\t")

medl <- median(rep.int(0:maxdepth, tl))
medh <- median(rep.int(0:maxdepth, th))

write(medl, paste0(lowDir,"/autoChr_lowDepth.depthMedian"), ncolumns=1)
write(medh, paste0(highDir,"/autoChr_highDepth.depthMedian"), ncolumns=1)

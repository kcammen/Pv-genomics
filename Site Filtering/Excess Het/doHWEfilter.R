library(RcppCNPy)

estF <- scan("~/local_path_to_project/Excess Het/results/Pv.nomisID.noThy.mapQ30.depthfilter.autosomes.HWE.inbreed.sites")
lrt <- scan("~/local_path_to_project/Excess Het/results/Pv.nomisID.noThy.mapQ30.depthfilter.autosomes.HWE.lrt.sites")

site <- scan("~/local_path_to_project/Excess Het/results/Pv.nomisID.noThy.mapQ30.depthfilter.autosomes.beagle.sites",what="df")
site <- site[-1] #remove column header

#determine LRT threshold that results in p value threshold of 1e-6 
HWEfilter_sites <- scan("~/local_path_to_project/Excess Het/results/Pv.nomisID.noThy.mapQ30.depthfilter.autosomes.hweFilter.sites.sites",what="df")
min(lrt[which(HWEfilter_sites == "0")])
#[1] 23.92816
max(lrt[which(HWEfilter_sites == "1")])
#[1] 23.92758
#use lrt > 24 as threshold for identifying bad positions

chr <- sub("_[0123456789]+$","",x=site)
pos <- as.integer(sub(".*_","",x=site))

chrs <- unique(chr)

maxPos <- tapply(pos,chr,max)
meanF <- tapply(estF,chr,mean)
lenF <- tapply(estF,chr,length)

badRegions <- function(ch, minF, reg){
    k <- chr == ch
    # get bad sites (meanF below minF and significantly deviating hwe)
    badpos <- pos[k][lrt[k] > 24 & estF[k] < minF] # lrt 24 equivales pvalue of 1e-6
    
    if(length(badpos)==0) return(data.frame(chr=ch, start=1, end=1))
    # get regions reg (default 50000) bp in both directions of bad sites                             
    badreg <- matrix(c(badpos-reg, badpos+reg), ncol=2)
    badreg[badreg<0] <- 1

    if(nrow(badreg)==1) return(data.frame(chr=ch,start= badreg[1,1], end= badreg[1,2]))
    # collapse overlapping regions
    badreg2 <- c()
    start <- badreg[1,1]
    end <- badreg[1,2]
    for(i in 2:nrow(badreg)){

        if(badreg[i,1]<end){
            end <- badreg[i,2]
        }else{
            badreg2 <- c(badreg2, start, end)
            start <- badreg[i,1]
            end <- badreg[i,2]
        }
    }

    badreg2 <- c(badreg2,start,end)
    
    badreg <- t(matrix(badreg2,nrow=2))
    #out <- cbind(rep(ch, nrow(badreg)), badreg)
    out <- data.frame(chr=rep(ch,nrow(badreg)), start = badreg[,1], end = badreg[,2])
    out$start <- out$start - 1
    return(out) 
}

rmreg <- 10000 #Impala paper uses within 10kbp, giraffe and leopard uses 100kbp window (= within 50000kbp)
minf <- -0.9 #Impala paper uses -.9, giraffe and leopard uses -.95

badbedl <- lapply(chrs, badRegions,minF= minf, reg=rmreg)

badbed <- do.call('rbind', badbedl)

allbed <- read.table("~/local_path_to_project/Depth/GSC_HSeal_1.0_HiC.autosomes.bed")

lost <- sum(as.numeric(badbed$end-badbed$start))/sum(as.numeric(allbed$V3))

names(allbed) <- names(badbed)

lenghtbad <- tapply(badbed$end-badbed$start, badbed$chr, sum)

Nbadreg <- tapply(badbed$chr, badbed$chr, length)* (lenghtbad>0)

k <- names(meanF)
length(chrs)

summarydf <- data.frame(chr=chrs, length=allbed$end,meanF=meanF[chrs],
                        proportionBad=lenghtbad/allbed$end,
                        Nbadregions=Nbadreg,
#                        keep = TRUE)
                        keep= ifelse(names(meanF[chrs])%in%names(lenghtbad),!(lenghtbad/allbed$end > 0.5 | meanF[chrs] < -0.2),FALSE))



write.table(summarydf,paste0("~/local_path_to_project/Excess Het/results/","InbreedSummary_minF",minf,"_rm", rmreg * 2,"k.tsv"),
            col.names=TRUE, row.names=FALSE, quote=FALSE, sep="\t")

w <- names(sort(meanF))
require(scales) # for alpha funciton in plot

## plot 
pdf(paste0("~/local_path_to_project/Excess Het/results/","scaffPlotLen_minF",minf,"_rm", rmreg * 2,"k.pdf"))
for(i in 1:15){

    scaf <- chrs[i]

    p<-pos[chr==scaf]
    F<-estF[chr==scaf]
    l <- lrt[chr==scaf]

    plot(p,F,pch=4,col=ifelse(F< .9 & l>24, "goldenrod","grey"),lwd=2,ylab="F",xlab="position", main=scaf,cex.lab=1.8,cex.axis=1.8,cex.main=1.8)
    #goldenrod = positions with excessive heterozygosity

    win <- 200
    fun<-function(x,w) ( cumsum(as.numeric(x))[-c(1:w)]-rev(rev(cumsum(as.numeric(x)))[-c(1:w)])) / w
    lines(fun(p,win),fun(F,win))

    start <- badbed[badbed$chr==scaf,]$start
    end <- badbed[badbed$chr==scaf,]$end
    abline(v=start, col="darkred",lwd=1)
    abline(v=end, col="darkred",lwd=1)

    #segments(y0=-1, y1=1, x0=start, x1=end, col="darkred")
    #segments(y0=1, y1=-1, x0=start, x1=end, col="darkred")
    #cat("doing chr", scaf,"\n")
    if(length(start)>0) rect(xleft=start,xright=end,ybottom=-1.5,ytop=1.5,col=scales::alpha("grey",0.5), border =NA)
}
dev.off()

badbed <- badbed[badbed$end > 1,]

finalbadbed <- rbind(badbed, data.frame(chr=summarydf$chr[!summarydf$keep],
                                start=rep(0, sum(!summarydf$keep)),
                                end=summarydf$length[!summarydf$keep]))

write.table(finalbadbed, paste0("~/local_path_to_project/Excess Het/results/","excludelistInbreedSites_minF", minf, "_rm", rmreg*2,"_unmerged_unsorted.BED"), col.names=FALSE, row.names=FALSE, quote=FALSE, sep="\t")

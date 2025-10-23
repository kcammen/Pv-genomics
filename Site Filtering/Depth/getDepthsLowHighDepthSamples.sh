#!/bin/bash

module load angsd

bamslow=/path_to_project/depth/Pv.bam.list.noNovoGene.nomisID.noThyout.low.txt
bamshigh=/path_to_project/depth/Pv.bam.list.noNovoGene.nomisID.noThyout.high.txt

chrs=/path_to_ref/GSC_HSeal_1.0_HiC.autosomes.txt
out=/path_to_project/depth

cat ${chrs} | while read chr
do
    echo angsd -minq 30 -minmapq 30 -doCounts 1 -doDepth 1 -dumpCounts 1 -maxdepth 6000 -b ${bamslow} -out ${out}/lowDepth/${chr}_lowDepth -r $chr
    echo angsd -minq 30 -minmapq 30 -doCounts 1 -doDepth 1 -dumpCounts 1 -maxdepth 5000 -b ${bamshigh} -out ${out}/highDepth/${chr}_highDepth -r $chr
done | xargs -L 1 -I CMD -P 10 bash -c CMD

#!/bin/bash

module load perl/5.38.0 gsl/2.5 bcftools/1.21

poplist=/path_to_project/heterozygosity_window/popfile.txt
windowbedfile=/path_to_project/heterozygosity_window/slidingwindows.100kb.100kb.bed

awk -F'\t' '{print $1 \t $2 \t $3}' ${windowbedfile} > pop_avg_slidingwindow.het

cat ${poplist} | while read pop; do

  awk -F'\t' '{
      sum = 0;
      count = 0;
      for (i = 4; i <= NF; i++) {
        sum += $i;
        count++;
      }
      avg = (count > 0) ? sum / count : 0;
      print avg
  }' ${pop}_combined_slidingwindow.het > ${pop}_avg_slidingwindow.het

  paste pop_avg_slidingwindow.het ${pop}_avg_slidingwindow.het > pop_avg_tmp && mv pop_avg_tmp pop_avg_slidingwindow.het

done

(echo -e "chr\tstart\tend\t$(paste -sd'\t' ${poplist})"; cat pop_avg_slidingwindow.het) > pop_avg_slidingwindow_wHeaders.het

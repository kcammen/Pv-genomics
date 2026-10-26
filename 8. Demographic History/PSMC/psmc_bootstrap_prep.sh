#!/bin/bash

module load gcc/13.2.0 gnuplot/6.0.0 psmc/0.6.5

samplelist=/path_to_project/psmc/PSMC_samples_wopilot.csv

for file in $(cat ${samplelist})
do
    ID=`echo ${file} | cut -f1 -d ","`
    mkdir bootstraps/${ID}
    
    #Split long chromosome sequences to shorter segments. 
    splitfa ${ID}.dedup.RepeatMasker.consensus.bcftools.psmcfa > split.${ID}.dedup.RepeatMasker.consensus.bcftools.psmcfa
    
    #Generate lines of code to run PSMC 100 times with the `-b' option indicating that it should randomly sample with replacement from the split segments.
    seq 10 | xargs -P 1 -i echo psmc -N25 -t15 -r5 -b -p ^4+25*2+4+6^ -o bootstraps/${ID}/round_${ID}-{}.psmc split.${ID}.dedup.RepeatMasker.consensus.bcftools.psmcfa "&" >> split.${ID}.dedup.RepeatMasker.consensus.bcftools.bootstrap.commands.sh
    sed -i 's/\^/\"/g' split.${ID}.dedup.RepeatMasker.consensus.bcftools.bootstrap.commands.sh

    # Remove '&' from every 10th line  
    sed -i '0~10s/ &$//' split.${ID}.dedup.RepeatMasker.consensus.bcftools.bootstrap.commands.sh

    # Remove '&' from last line
    sed -i '$s/ &$//' split.${ID}.dedup.RepeatMasker.consensus.bcftools.bootstrap.commands.sh

    echo "
#!/bin/bash

module load gcc/13.2.0 gnuplot/6.0.0 psmc/0.6.5

bash split.${ID}.dedup.RepeatMasker.consensus.bcftools.bootstrap.commands.sh

    " > run.boostraps.${ID}.sh

done

sed -i '0,/^[[:space:]]*$/d' run.boostraps.*.sh



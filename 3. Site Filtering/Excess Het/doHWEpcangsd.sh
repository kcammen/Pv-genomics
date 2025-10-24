#!/bin/bash

module load pcangsd

beagle=/path_to_project/excess_het/results/Pv.nomisID.noThy.mapQ30.depthfilter.autosomes.beagle.gz
out=/path_to_project/excess_het/results/Pv.nomisID.noThy.mapQ30.depthfilter.autosomes.HWE

pcangsd --beagle ${beagle} --sites_save --inbreed_sites -o ${out} --threads 10 > $out.log

#!/bin/bash

module load ngsrelate/2.0

glf=/path_to_project/related/Pv.nomisID.noThy.mapQ30.autosomes.glf.gz
freqs=/path_to_project/related/Pv.nomisID.noThy.mapQ30.autosomes.freqs.txt
IDs=/path_to_project/related/Pv.IDs.list.noNovoGene.nomisID.noThyout.txt
out=/path_to_project/related/Pv.nomisID.noThy.mapQ30.autosomes.out

ngsRelate -g ${glf} -n 183 -f ${freqs} -z ${IDs} -p 10 -O ${out}

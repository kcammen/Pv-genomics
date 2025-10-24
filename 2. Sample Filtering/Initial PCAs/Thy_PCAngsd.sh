#!/bin/bash

module load pcangsd

beagle=/path_to_project/init_pcangsd/Pv.nomisID.mapQ30.autosomes.beagle.gz
out=/path_to_project/init_pcangsd/Pv.nomisID.GL.mapQ30.autosomes

pcangsd --beagle ${beagle} -o ${out} --threads 5


#!/bin/bash

module load cactus/2.9.9

#toil clean jobstore

cactus-preprocess --restart jobstore/0 seqFile.txt steps-output/Pv_align.txt --inputNames Martes_foina Halichoerus_grypus Phoca_vitulina Phoca_largha --logFile steps-output/logs/preprocess-Martes_foina.log

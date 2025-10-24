#!/bin/bash

module load python/3.12.8

mkdir bootstraps/GOM_GRN

python3 bootstrap_smcpp_GOM_GRN.py
python3 bootstrap_smcpp_GRN_GOM.py

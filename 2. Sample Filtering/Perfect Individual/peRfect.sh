#!/bin/bash

module load gcc/11.2.0 R/4.3.1

Rscript estError.R file=error.ancError

#modified from https://github.com/popgenmethods/smcpp/issues/37

import click
import argparse
import os
import sys
import random
import gzip
import time
import glob
import re

def get_bp_size(file):
    offset = 0
    with gzip.open(file, 'rb') as f:
        f.readline()  # skip header
        for line in f:
            line = [int(x) for x in line.decode().strip().split()]
            offset += line[0]
    return offset

def natural_key(s):
    """
    Sort key that treats numbers in strings as integers,
    so 'file2' comes before 'file10'.
    """
    filename = os.path.basename(s)  # remove the path
    return [int(t) if t.isdigit() else t for t in re.split(r'(\d+)', filename)]

def main(nr_bootstraps, chunk_size, nr_chromosomes, seed, out_dir_prefix, files):
    chunks = []
    offset = 0
    chunks_in_chrom = []
    if not seed:
        seed = int(time.time())
    random.seed(seed)
    print('seed: %s' % seed)
    for file in files:
        with gzip.open(file, 'rb') as f:
            header = f.readline().decode()
            for line in f:
                line = line.decode()
                line = [int(x) for x in line.strip().split()]
                pos = line[0] + offset
                offset += line[0]
                chunk_index = (pos - 1) // chunk_size
                if chunk_index > len(chunks_in_chrom)-1:
                    chunks_in_chrom.append([])
                chunks_in_chrom[chunk_index].append(line)
        chunks.extend(chunks_in_chrom)

    chrom_sizes = [get_bp_size(file) for file in files]  # e.g., [98_000_000, 76_000_000, ...]
    total_genome = sum(chrom_sizes)
    proportions = [size / total_genome for size in chrom_sizes]

    for bootstrap_id in range(1, nr_bootstraps +1):
        for chr_ in range(1, nr_chromosomes + 1):
            chr_dir = "{}_{}".format(out_dir_prefix, bootstrap_id)
            if not os.path.exists(chr_dir):
                os.makedirs(chr_dir)
            chr_file = "{}/GOM_bootstrap_chr{}.gz".format(chr_dir, chr_)
            print("writing", chr_file, file=sys.stderr)
                        
            chrom_size = chrom_sizes[chr_ - 1]  # Get the size for this chromosome
            chunks_needed = int(round(chrom_size / chunk_size))
            print(f"Chromosome {chr_} needs {chunks_needed} chunks")
            
            with gzip.open(chr_file, 'wb') as f:
                f.write(header.encode())
                for i in range(chunks_needed):
                    chunk_id = random.randrange(len(chunks))
                    for line in chunks[chunk_id]:
                        line = ' '.join([str(x) for x in line]) + '\n'
                        f.write(line.encode())

nr_bootstraps = 20
chunk_size = 5000000
nr_chromosomes = 15
seed=42
out_dir_prefix = "/path_to_project/smcpp/bootstraps/GOM/GOM"
files = sorted(glob.glob("/path_to_project/smcpp/smc_files/GOM_HiC_scaffold*.smc.gz"), key=natural_key)
print(files)

if __name__ == "__main__":
    main(nr_bootstraps, chunk_size, nr_chromosomes, seed, out_dir_prefix, files)

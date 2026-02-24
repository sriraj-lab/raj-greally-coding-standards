# First Week Project: From VCF to Results

A structured 5-part onboarding project designed to take 3-5 days. By the end, you will have hands-on experience with every tool you need for computational genomics work on the Einstein HPC.

---

## Learning Objectives

By completing this project, you will be able to:

- **SSH** into the HPC and navigate between login and compute nodes
- **Bash** -- use core command-line tools to inspect and manipulate genomic files
- **Conda** -- activate environments and manage Python dependencies
- **SLURM** -- submit batch jobs, monitor them, and debug failures
- **Git** -- version control your scripts and push to GitHub
- **Documentation** -- write a NOTES.md that lets someone else reproduce your work

---

## Part 1: Setup (Day 1)

**Goal:** Confirm your HPC environment is fully working.

### Tasks

1. **Clone this repository** to your local machine:
   ```bash
   git clone <repo-url>
   cd raj-greally-coding-standards
   ```

2. **Set up SSH** following `DAY_ONE.md` in this directory. Verify you can:
   ```bash
   ssh hpc-login        # Lands on login node
   ```

3. **Copy and source the starter bashrc:**
   ```bash
   scp 00-quickstart/starter.bashrc hpc-login:~/.bashrc_starter
   ssh hpc-login
   # On HPC: review, then apply
   cp ~/.bashrc_starter ~/.bashrc
   source ~/.bashrc
   ```

4. **Start an interactive job:**
   ```bash
   # On the login node:
   interactive
   # Note the node name (e.g., cpu-743)
   ```

5. **Update your local SSH config** (in a new local terminal):
   ```bash
   setnode cpu-743    # Use your actual node name
   ssh hpc-compute    # Verify direct compute access
   ```

6. **Activate conda and verify:**
   ```bash
   conda activate local_pca
   python --version
   python -c "import pandas; import numpy; print('Ready!')"
   ```

### Checkpoint

You should be able to run all of the above without errors. If anything fails, troubleshoot with your lab manager before moving on.

---

## Part 2: Bash Basics (Day 1-2)

**Goal:** Use core command-line tools to explore a VCF file.

A VCF (Variant Call Format) file stores genetic variant data. Each row is a variant (e.g., a SNP), and columns describe its position, reference/alternate alleles, and per-sample genotype calls. Lines starting with `##` are metadata headers, and the line starting with `#CHROM` is the column header.

### Required Commands

You will use all of these during this section. If any are unfamiliar, look them up with `man <command>` or search online.

| Command | What it does |
|---------|-------------|
| `cd` | Change directory |
| `ls` | List files |
| `cat` | Print entire file contents |
| `head` | Print first N lines |
| `tail` | Print last N lines |
| `grep` | Search for patterns in text |
| `wc` | Count lines, words, characters |
| `\|` (pipe) | Send output of one command to another |
| `>` | Redirect output to a file (overwrite) |
| `>>` | Redirect output to a file (append) |
| `awk` | Column-based text processing |
| `sort` | Sort lines |
| `uniq` | Remove or count duplicate lines |

### Tasks

All tasks should be done on the compute node (`ssh hpc-compute`).

```
# TO_FILL: Replace with the path to a test VCF file in the lab directory.
# Ask your lab manager for the location of a test/example VCF.
VCF="/gs/gsfs0/users/raj-lab/TO_FILL/test_data/example.vcf.gz"
```

1. **Navigate to the test data:**
   ```bash
   cd /gs/gsfs0/users/raj-lab/    # TO_FILL: navigate to the test VCF directory
   ls -lah
   ```

2. **Count total lines** in the VCF (use `zcat` for gzipped files):
   ```bash
   zcat $VCF | wc -l
   ```

3. **View the header** (metadata lines start with `##`):
   ```bash
   zcat $VCF | grep "^##" | head -20
   ```

4. **Find the column header** (starts with `#CHROM`):
   ```bash
   zcat $VCF | grep "^#CHROM"
   ```

5. **Count the number of samples** (columns 10 onward are samples):
   ```bash
   zcat $VCF | grep "^#CHROM" | awk '{print NF - 9}'
   ```

6. **Count variants per chromosome:**
   ```bash
   zcat $VCF | grep -v "^#" | awk '{print $1}' | sort | uniq -c | sort -rn
   ```

7. **Extract chromosome 22 variants** into a new file:
   ```bash
   # Keep header lines, then filter for chr22 data lines
   zcat $VCF | grep "^#" > chr22.vcf
   zcat $VCF | grep -v "^#" | awk '$1 == "22" || $1 == "chr22"' >> chr22.vcf
   wc -l chr22.vcf
   ```

8. **Find the most common alternate alleles** on chr22:
   ```bash
   grep -v "^#" chr22.vcf | awk '{print $5}' | sort | uniq -c | sort -rn | head -10
   ```

### Checkpoint

Write down the answers to these questions (you will include them in your NOTES.md later):
- How many total lines are in the VCF?
- How many samples?
- How many variants on chromosome 22?
- What are the top 3 most common alternate alleles?

---

## Part 3: SLURM Batch Jobs (Day 2-3)

**Goal:** Convert an interactive command into a batch job, submit it, monitor it, and debug a failure.

SLURM is the job scheduler. Instead of running commands interactively, you write a script that SLURM runs on your behalf on a compute node. This is essential for long-running or resource-intensive tasks.

### Task 3a: Your First Batch Script

Create a file called `extract_chr22.sbatch` locally:

```bash
#!/bin/bash
#SBATCH --job-name=extract_chr22
#SBATCH --partition=quick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --output=logs/chr22_%j.out
#SBATCH --error=logs/chr22_%j.err

echo "Job ID: ${SLURM_JOB_ID}"
echo "Node: ${SLURM_NODELIST}"
echo "Start time: $(date)"

# TO_FILL: Set the correct VCF path
VCF="/gs/gsfs0/users/raj-lab/TO_FILL/test_data/example.vcf.gz"
OUTDIR="/gs/gsfs0/users/raj-lab/TO_FILL/yourname/first_week"

mkdir -p ${OUTDIR}

# Extract chr22
zcat ${VCF} | grep "^#" > ${OUTDIR}/chr22.vcf
zcat ${VCF} | grep -v "^#" | awk '$1 == "22" || $1 == "chr22"' >> ${OUTDIR}/chr22.vcf

echo "Variants extracted: $(grep -cv '^#' ${OUTDIR}/chr22.vcf)"
echo "End time: $(date)"
```

### Task 3b: Submit and Monitor

```bash
# Copy script to HPC
scp extract_chr22.sbatch hpc-login:/gs/gsfs0/users/raj-lab/TO_FILL/yourname/

# SSH to login node and submit
ssh hpc-login

# Create logs directory first
mkdir -p /gs/gsfs0/users/raj-lab/TO_FILL/yourname/logs

# Submit the job
sbatch /gs/gsfs0/users/raj-lab/TO_FILL/yourname/extract_chr22.sbatch

# Check job status
squeue -u $USER

# Once complete, check output
cat /gs/gsfs0/users/raj-lab/TO_FILL/yourname/logs/chr22_*.out
```

### Task 3c: Intentional Failure

Learning to debug failed jobs is just as important as writing them. Modify your script to introduce a deliberate error:

```bash
# Change the VCF path to something that does not exist
VCF="/gs/gsfs0/users/raj-lab/DOES_NOT_EXIST/fake.vcf.gz"
```

Submit it, wait for it to finish, then inspect:

```bash
# Check the job's exit code
sacct --format=JobID,JobName,State,ExitCode -u $USER -S now-1hour

# Read the error log
cat /gs/gsfs0/users/raj-lab/TO_FILL/yourname/logs/chr22_*.err
```

**Questions to answer:**
- What state does the job show? (COMPLETED, FAILED, etc.)
- What is the exit code?
- What error message appears in the `.err` file?

Fix the error and resubmit to verify it works.

### Task 3d: Array Job

An array job runs the same script multiple times with different parameters. This is the standard pattern for processing multiple chromosomes in parallel.

Create `extract_chrs.sbatch`:

```bash
#!/bin/bash
#SBATCH --job-name=extract_chrs
#SBATCH --partition=quick
#SBATCH --array=20-22
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --output=logs/chr%a_%j.out
#SBATCH --error=logs/chr%a_%j.err

# SLURM_ARRAY_TASK_ID is automatically set to the current array index
CHR=${SLURM_ARRAY_TASK_ID}

echo "Processing chromosome ${CHR}"
echo "Job ID: ${SLURM_JOB_ID}, Array Task: ${SLURM_ARRAY_TASK_ID}"

# TO_FILL: Set paths
VCF="/gs/gsfs0/users/raj-lab/TO_FILL/test_data/example.vcf.gz"
OUTDIR="/gs/gsfs0/users/raj-lab/TO_FILL/yourname/first_week"

mkdir -p ${OUTDIR}

zcat ${VCF} | grep "^#" > ${OUTDIR}/chr${CHR}.vcf
zcat ${VCF} | grep -v "^#" | awk -v chr="${CHR}" '$1 == chr || $1 == "chr"chr' >> ${OUTDIR}/chr${CHR}.vcf

echo "Chr${CHR} variants: $(grep -cv '^#' ${OUTDIR}/chr${CHR}.vcf)"
echo "Done: $(date)"
```

Submit and monitor:

```bash
sbatch extract_chrs.sbatch

# Watch all array tasks
squeue -u $USER

# After completion, check all outputs
cat logs/chr*_*.out
```

### Checkpoint

You should have:
- Successfully submitted a single job
- Observed and debugged a failed job
- Run an array job for chromosomes 20-22
- Three chr VCF files in your output directory

---

## Part 4: Python + Conda (Day 3-4)

**Goal:** Use Python to read genomic data, compute summary statistics, and generate a plot -- all submitted via SLURM.

### Task 4a: Write the Python Script

Create `vcf_stats.py` locally:

```python
"""Compute basic stats from extracted VCF files and generate a plot."""

import sys
import os
import pandas as pd
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend (no display needed on HPC)
import matplotlib.pyplot as plt

# Input: directory containing chr*.vcf files
input_dir = sys.argv[1]
output_dir = sys.argv[2]
os.makedirs(output_dir, exist_ok=True)

# Count variants per chromosome
results = []
for vcf_file in sorted(os.listdir(input_dir)):
    if vcf_file.startswith("chr") and vcf_file.endswith(".vcf"):
        chr_name = vcf_file.replace(".vcf", "")
        filepath = os.path.join(input_dir, vcf_file)

        n_variants = 0
        with open(filepath) as f:
            for line in f:
                if not line.startswith("#"):
                    n_variants += 1

        results.append({"chromosome": chr_name, "n_variants": n_variants})
        print(f"{chr_name}: {n_variants} variants")

# Create DataFrame and save
df = pd.DataFrame(results)
df.to_csv(os.path.join(output_dir, "variant_counts.csv"), index=False)
print(f"\nSaved variant counts to {output_dir}/variant_counts.csv")

# Plot
fig, ax = plt.subplots(figsize=(8, 4))
ax.bar(df["chromosome"], df["n_variants"], color="steelblue")
ax.set_xlabel("Chromosome")
ax.set_ylabel("Number of Variants")
ax.set_title("Variant Counts per Chromosome")
plt.tight_layout()

plot_path = os.path.join(output_dir, "variant_counts.png")
fig.savefig(plot_path, dpi=150)
print(f"Saved plot to {plot_path}")
```

### Task 4b: Write the SLURM Script

Create `run_vcf_stats.sbatch`:

```bash
#!/bin/bash
#SBATCH --job-name=vcf_stats
#SBATCH --partition=quick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=00:30:00
#SBATCH --output=logs/vcf_stats_%j.out
#SBATCH --error=logs/vcf_stats_%j.err

echo "Job ID: ${SLURM_JOB_ID}"
echo "Start: $(date)"

# IMPORTANT: Activate conda properly in SLURM scripts.
# `conda run` does NOT work. You must source bashrc first.
source ~/.bashrc
conda activate local_pca

# TO_FILL: Set paths
INPUT_DIR="/gs/gsfs0/users/raj-lab/TO_FILL/yourname/first_week"
OUTPUT_DIR="/gs/gsfs0/users/raj-lab/TO_FILL/yourname/first_week/results"

python vcf_stats.py ${INPUT_DIR} ${OUTPUT_DIR}

echo "End: $(date)"
```

### Task 4c: Run It

```bash
# Copy both files to HPC
scp vcf_stats.py run_vcf_stats.sbatch hpc-login:/gs/gsfs0/users/raj-lab/TO_FILL/yourname/

# Submit
ssh hpc-login "cd /gs/gsfs0/users/raj-lab/TO_FILL/yourname && sbatch run_vcf_stats.sbatch"

# Monitor
ssh hpc-login "squeue -u $USER"

# Check output when done
ssh hpc-login "cat /gs/gsfs0/users/raj-lab/TO_FILL/yourname/logs/vcf_stats_*.out"
```

### Task 4d: Retrieve the Plot

```bash
# Copy the plot to your local machine to view it
scp hpc-login:/gs/gsfs0/users/raj-lab/TO_FILL/yourname/first_week/results/variant_counts.png ./
open variant_counts.png    # macOS
```

### Checkpoint

You should have:
- A `variant_counts.csv` with per-chromosome counts
- A `variant_counts.png` bar chart
- Both generated via a SLURM job (not interactively)

---

## Part 5: Git + Documentation (Day 4-5)

**Goal:** Version control your scripts and document your work.

### Task 5a: Initialize a Git Repository

On your local machine:

```bash
mkdir ~/first-week-project
cd ~/first-week-project
git init
```

### Task 5b: Create a .gitignore

```bash
# Data files -- never commit large data to git
*.vcf
*.vcf.gz
*.bed
*.bim
*.fam
*.bgen

# Results that can be regenerated
*.png
*.csv

# Logs
logs/

# OS files
.DS_Store
```

### Task 5c: Add Your Scripts

Copy the scripts you created into this directory and commit them:

```bash
cp /path/to/your/extract_chr22.sbatch .
cp /path/to/your/extract_chrs.sbatch .
cp /path/to/your/vcf_stats.py .
cp /path/to/your/run_vcf_stats.sbatch .

git add extract_chr22.sbatch extract_chrs.sbatch vcf_stats.py run_vcf_stats.sbatch .gitignore
git commit -m "Add first-week onboarding scripts: VCF extraction and stats"
```

**Important:** Commit scripts, not data. The `.gitignore` prevents accidentally adding large files.

### Task 5d: Write a NOTES.md

Create a `NOTES.md` file documenting your work. This is the most important deliverable -- it ensures your work is reproducible.

```markdown
# First Week Project Notes

## Date
YYYY-MM-DD

## Data Location
- **Input VCF:** /gs/gsfs0/users/raj-lab/TO_FILL/test_data/example.vcf.gz
- **Output directory:** /gs/gsfs0/users/raj-lab/TO_FILL/yourname/first_week/
- **Results:** /gs/gsfs0/users/raj-lab/TO_FILL/yourname/first_week/results/

## Scripts
| Script | Purpose | How to run |
|--------|---------|-----------|
| extract_chr22.sbatch | Extract chr22 from VCF | `sbatch extract_chr22.sbatch` |
| extract_chrs.sbatch | Array job for chr20-22 | `sbatch extract_chrs.sbatch` |
| vcf_stats.py | Compute variant counts, generate plot | Called by run_vcf_stats.sbatch |
| run_vcf_stats.sbatch | SLURM wrapper for vcf_stats.py | `sbatch run_vcf_stats.sbatch` |

## Results Summary
- Total lines in VCF: ___
- Number of samples: ___
- Chr22 variants: ___
- Top 3 alternate alleles: ___

## Lessons Learned
[What was confusing? What do you want to remember?]
```

```bash
git add NOTES.md
git commit -m "Add project notes with data locations and results summary"
```

### Task 5e: Push to GitHub

```bash
# Create a new repository on GitHub (via browser or gh CLI)
# Then:
git remote add origin git@github.com:<your-username>/first-week-project.git
git branch -M main
git push -u origin main
```

### Checkpoint

Your GitHub repository should contain:
- 4 scripts (2 sbatch, 1 Python, 1 sbatch wrapper)
- `.gitignore`
- `NOTES.md`
- No data files, no log files, no images

---

## Deliverables and Assessment

This project is assessed on **completion and documentation**, not code quality. You are learning tools, not writing production software.

### Required Deliverables

| # | Deliverable | Criteria |
|---|------------|----------|
| 1 | SSH access working | Can `ssh hpc-login` and `ssh hpc-compute` |
| 2 | Conda environment working | Can activate `local_pca` and import pandas/numpy |
| 3 | Bash exploration answers | All Part 2 checkpoint questions answered in NOTES.md |
| 4 | Successful single SLURM job | `extract_chr22.sbatch` runs to completion |
| 5 | Debugged a failed job | Can explain what went wrong and how you fixed it |
| 6 | Successful array job | `extract_chrs.sbatch` produces chr20.vcf, chr21.vcf, chr22.vcf |
| 7 | Python stats + plot | `variant_counts.csv` and `variant_counts.png` generated via SLURM |
| 8 | Git repository | Pushed to GitHub with scripts, .gitignore, and NOTES.md |
| 9 | NOTES.md | Documents data locations, scripts, results, and lessons learned |

### Assessment Approach

- **Pass:** All 9 deliverables complete, NOTES.md has enough detail for someone else to reproduce your work.
- **Needs revision:** Missing deliverables or NOTES.md lacks data paths/script descriptions. Revise and resubmit.

There is no "fail" -- take as long as you need. The goal is learning, not speed.

---

## Getting Help

- **Something is not working:** Check the error log (`.err` file) first, then ask your lab manager.
- **Confused about a command:** Use `man <command>` or search "bash \<command\> tutorial".
- **SLURM questions:** Run `squeue -u $USER` and `sacct` to investigate before asking.
- **General questions:** Ask in the lab Slack channel -- someone else probably had the same question.


# TODOs

- [ ] Make solutions for students- use old TA scripts for auto-grade

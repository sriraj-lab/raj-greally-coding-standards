#!/bin/bash
###############################################################################
# SLURM Batch Script Template
#
# Usage:
#   1. Copy this file and rename for your job
#   2. Adjust directives below for your resource needs
#   3. Submit: sbatch your_script.sbatch
#
# Two variants are included:
#   - Single Job (default, uncommented)
#   - Array Job (commented out, for parallel chromosome/chunk processing)
###############################################################################

#=============================================================================
# SLURM DIRECTIVES
#=============================================================================

# Job name: shows up in squeue output. Keep it short and descriptive.
#SBATCH --job-name=my_job

# Partition: determines max CPUs and wall time.
#   quick    - max 16 CPUs, max 4 hours   (testing, short preprocessing)
#   ht       - no CPU cap,  max 1 day     (medium jobs)
#   normal   - no CPU cap,  max 3 days    (large jobs)
#   infinite - no CPU cap,  no time limit (very long jobs)
# NOTE: If you need >16 CPUs, you MUST use ht, normal, or infinite.
#SBATCH --partition=quick

# Cluster: only specify if targeting a specific cluster (e.g., hpc4).
# Omit this line to use the default cluster.
##SBATCH --cluster=hpc4

# Nodes: almost always 1 for single-machine jobs.
#SBATCH --nodes=1

# Tasks: number of independent processes (for MPI jobs).
# For most Python/R scripts, this is 1.
#SBATCH --ntasks=1

# CPUs per task: number of CPU cores available to your script.
# Python multiprocessing, pandas parallel, etc. use these.
# Remember: quick partition caps at 16.
#SBATCH --cpus-per-task=8

# Memory: two options (use one, not both):
#   --mem-per-cpu=12G   (memory per CPU core, scales with cpus-per-task)
#   --mem=96G           (total memory for the job, fixed)
# Typical: 8-20G per CPU for most tasks.
#SBATCH --mem-per-cpu=12G

# Wall time: maximum duration before SLURM kills the job.
# Format: HH:MM:SS or D-HH:MM:SS
# Tip: overestimate slightly, but don't request infinite if you don't need it.
#SBATCH --time=01:00:00

# Output and error logs: %j is replaced with the job ID.
# Create the log directory before submitting!
#SBATCH --output=logs/job_%j.out
#SBATCH --error=logs/job_%j.err

# Email notifications (optional):
##SBATCH --mail-type=END,FAIL
##SBATCH --mail-user=your.email@institution.edu

#=============================================================================
# ARRAY JOB VARIANT (uncomment to use)
#=============================================================================
# Array jobs create multiple independent jobs from one script.
# Each gets a unique SLURM_ARRAY_TASK_ID.
#
# Common uses:
#   --array=1-22        (one job per chromosome)
#   --array=1-100       (100 parallel chunks)
#   --array=1-22%5      (22 jobs, max 5 running at once)
#
##SBATCH --array=1-22
#
# In the script body, use:
#   CHR=${SLURM_ARRAY_TASK_ID}
#
# For array jobs, use %a in output/error paths for the array task ID:
##SBATCH --output=logs/chr%a_%j.out
##SBATCH --error=logs/chr%a_%j.err

#=============================================================================
# JOB PREAMBLE
#=============================================================================

# Print job metadata (useful for debugging and logs)
echo "============================================"
echo "Job ID:      ${SLURM_JOB_ID}"
echo "Job Name:    ${SLURM_JOB_NAME}"
echo "Node:        ${SLURM_NODELIST}"
echo "CPUs:        ${SLURM_CPUS_PER_TASK}"
echo "Partition:   ${SLURM_JOB_PARTITION}"
echo "Start time:  $(date)"
echo "Working dir: $(pwd)"
echo "============================================"

#=============================================================================
# ENVIRONMENT SETUP
#=============================================================================

# Activate conda environment.
# IMPORTANT: Always use this pattern. Do NOT use `conda run` or hard-coded paths.
source ~/.bashrc
conda activate <env_name>

# Verify Python and key packages (optional but recommended for debugging)
echo "Python: $(which python)"
echo "Python version: $(python --version)"

#=============================================================================
# MAIN WORK
#=============================================================================

# --- Single job ---
python my_script.py \
    --input /path/to/input \
    --output /path/to/output \
    --threads ${SLURM_CPUS_PER_TASK}

# --- Array job (uncomment if using --array) ---
# CHR=${SLURM_ARRAY_TASK_ID}
# echo "Processing chromosome ${CHR}..."
# python my_script.py \
#     --chr ${CHR} \
#     --input /path/to/input/chr${CHR}.vcf.gz \
#     --output /path/to/output/chr${CHR}_results.tsv \
#     --threads ${SLURM_CPUS_PER_TASK}

#=============================================================================
# WRAP UP
#=============================================================================

echo "============================================"
echo "End time: $(date)"
echo "Exit code: $?"
echo "============================================"

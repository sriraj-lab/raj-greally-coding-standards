# SLURM Basics

SLURM (Simple Linux Utility for Resource Management) is the job scheduler on our HPC cluster. Instead of running computations directly on the login node, you write a batch script that describes what resources you need and what commands to run. SLURM then allocates a compute node and runs your job there.

This guide covers everything you need to submit, monitor, and troubleshoot SLURM jobs.

---

## Partitions

A **partition** is a queue of compute nodes with specific resource and time limits. Choose based on how long your job will run and how many CPUs it needs.

| Partition   | Max CPUs | Max Wall Time | Best For |
|-------------|----------|---------------|----------|
| `quick`     | 16       | 4 hours       | Testing, preprocessing, quick analyses |
| `ht`        | no cap   | 1 day         | Medium jobs, data generation |
| `normal`    | no cap   | 3 days        | Full-genome processing, large analyses |
| `infinite`  | no cap   | no limit      | Very long-running jobs (use sparingly) |

**Key rule:** If you need more than 16 CPUs, you must use `ht`, `normal`, or `infinite`. The `quick` partition will reject jobs requesting >16 CPUs.

**Guidance:**
- Start with `quick` for testing. Once your job works, move to `ht` or `normal` for production runs.
- Always request the smallest partition that fits your job. This reduces queue wait time.
- `infinite` should be reserved for jobs that genuinely cannot finish in 3 days.

---

## Annotated sbatch Template

Save this as a `.sbatch` file and submit it with `sbatch`. Every `#SBATCH` line is a directive that SLURM reads before running your script.

```bash
#!/bin/bash

# --- Job identity ---
#SBATCH --job-name=my_analysis        # Name shown in squeue. Keep it short and descriptive.

# --- Partition and time ---
#SBATCH --partition=quick             # Which queue to submit to (see table above).
#SBATCH --time=02:00:00              # Max wall time (HH:MM:SS). Job is killed if it exceeds this.

# --- Resource requests ---
#SBATCH --nodes=1                    # Number of nodes. Almost always 1 unless using MPI.
#SBATCH --ntasks=1                   # Number of tasks. Use >1 only for MPI programs.
#SBATCH --cpus-per-task=8            # CPUs allocated to your task. Match this to your code's parallelism.
#SBATCH --mem-per-cpu=12G            # Memory per CPU. Total memory = cpus-per-task * mem-per-cpu.

# --- Output files ---
#SBATCH --output=logs/job_%j.out     # Stdout log. %j is replaced with the job ID.
#SBATCH --error=logs/job_%j.err      # Stderr log. %j is replaced with the job ID.

# --- Optional: email notifications ---
# #SBATCH --mail-type=END,FAIL       # Uncomment to get emails when job ends or fails.
# #SBATCH --mail-user=you@example.com

# --- Print job metadata (useful for debugging) ---
echo "Job ID: ${SLURM_JOB_ID}"
echo "Node: ${SLURM_NODELIST}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"
echo "Start time: $(date)"

# --- Activate conda environment ---
source ~/.bashrc
conda activate local_pca

# --- Run your analysis ---
cd /path/to/project
python my_analysis.py

echo "End time: $(date)"
```

### Memory guidelines

- **Typical:** 8-20G per CPU for most bioinformatics tasks.
- **Large jobs:** Up to 200G total for tasks like whole-genome generation or large matrix operations.
- You can use `--mem=100G` instead of `--mem-per-cpu` to set a flat total memory limit.

---

## Array Jobs

An **array job** submits many copies of the same script, each with a different task ID. This is the standard pattern for per-chromosome processing.

```bash
#!/bin/bash
#SBATCH --job-name=pca_per_chr
#SBATCH --partition=ht
#SBATCH --array=1-22                 # Creates 22 jobs, one per autosome.
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=06:00:00
#SBATCH --output=logs/chr%a_%j.out   # %a = array task ID (1-22), %j = job ID
#SBATCH --error=logs/chr%a_%j.err

# The array task ID tells you which chromosome to process
CHR=${SLURM_ARRAY_TASK_ID}

echo "Processing chromosome ${CHR}, Job ID: ${SLURM_JOB_ID}"

source ~/.bashrc
conda activate local_pca

python process_chromosome.py --chr ${CHR}
```

**Output file placeholders:**
- `%j` — the overall job ID
- `%a` — the array task ID (the number from `--array`)

**Limiting concurrency:** If you do not want all 22 jobs running at once (for example, to avoid overwhelming a shared filesystem), use `--array=1-22%5` to run at most 5 at a time.

---

## Job Monitoring

### Check your running and pending jobs

```bash
squeue -u $USER
```

Output columns: `JOBID`, `PARTITION`, `NAME`, `USER`, `STATE`, `TIME` (elapsed), `NODES`, `NODELIST`.

Common states:
- `R` — Running
- `PD` — Pending (waiting for resources)
- `CG` — Completing (finishing up)

### Get detailed info on completed jobs

```bash
sacct --format=JobID,JobName,State,Start,Elapsed,ExitCode -u $USER -S now-1hour
```

The `-S now-1hour` flag shows jobs from the last hour. Adjust as needed (e.g., `-S 2025-01-15` for a specific date).

To check memory usage of a completed job (useful for diagnosing OOM kills):

```bash
sacct -j <job-id> --format=JobID,MaxRSS,MaxVMSize,Elapsed,State
```

### Cancel a job

```bash
# Cancel by job ID
scancel <job-id>

# Cancel all your jobs
scancel -u $USER

# Cancel a specific array task
scancel <job-id>_<task-id>

# For jobs on hpc4 cluster specifically
scancel -M hpc4 <job-id>
```

### Read job output

```bash
# View the full log
cat logs/job_12345.out

# Follow a running job's output in real time
tail -f logs/job_12345.out

# View last 50 lines
tail -50 logs/job_12345.out
```

---

## Common Job Patterns

### Single job, multiple CPUs

For a Python script that uses multiprocessing or a tool like `plink` that accepts `--threads`:

```bash
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=ht    # >16 CPUs requires ht/normal/infinite

python my_parallel_script.py --threads ${SLURM_CPUS_PER_TASK}
```

### High-memory job

For tasks that need a lot of RAM but not many CPUs:

```bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=200G        # Flat memory request instead of per-cpu
#SBATCH --partition=normal
```

### Job dependencies

Run job B only after job A succeeds:

```bash
# Submit job A, capture its job ID
JOB_A=$(sbatch --parsable job_a.sbatch)

# Submit job B, dependent on job A completing successfully
sbatch --dependency=afterok:${JOB_A} job_b.sbatch
```

Dependency types:
- `afterok:JOBID` — run only if JOBID completed successfully (exit code 0)
- `afterany:JOBID` — run after JOBID finishes regardless of exit code
- `afternotok:JOBID` — run only if JOBID failed

### Multiple parallel tasks within one job

Use background processes with `wait`:

```bash
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G

for i in 1 2 3 4; do
    python process_chunk.py --chunk ${i} &
done
wait  # Wait for all background processes to finish
echo "All chunks complete"
```

---

## Troubleshooting

### Job stuck in PD (Pending) forever

**Possible causes:**
- The partition is full. Check with `squeue -p <partition>` to see how busy it is.
- You requested more resources than any node can provide (e.g., 500G memory on nodes that have 256G).
- Your account has hit a resource limit.

**What to do:**
- Check the reason with `squeue -u $USER -o "%.18i %.9P %.8j %.8u %.8T %.10M %.6D %R"`. The last column (`REASON`) tells you why.
- Common reasons: `Resources` (waiting for nodes to free up), `Priority` (other jobs have higher priority).
- Consider switching to a less busy partition or reducing resource requests.

### Job killed immediately

**Possible causes:**
- Time limit exceeded: your `--time` was too short. Check with `sacct -j <job-id>` — state will show `TIMEOUT`.
- Out of memory: state will show `OUT_OF_MEMORY`. Check actual usage with `sacct -j <job-id> --format=JobID,MaxRSS,State`.
- Script error: check the `.err` file for Python tracebacks or other errors.

**What to do:**
- For time limits: increase `--time` and resubmit.
- For OOM: increase `--mem-per-cpu` or `--mem` and resubmit.
- For script errors: fix the script and resubmit.

### Socket timeout on sbatch

Sometimes `sbatch` will hang or report a socket communication error. **The job may still have been submitted.** Before resubmitting:

```bash
squeue -u $USER
```

If you see your job listed, it was submitted successfully despite the error. Do not resubmit or you will have duplicate jobs running.

### Job runs but produces no output

- Make sure the `--output` and `--error` paths exist. SLURM will not create parent directories for you.
- Check that your script's working directory (`cd`) is correct.
- Verify that conda was activated properly (see [CONDA_ENVIRONMENTS.md](CONDA_ENVIRONMENTS.md)).

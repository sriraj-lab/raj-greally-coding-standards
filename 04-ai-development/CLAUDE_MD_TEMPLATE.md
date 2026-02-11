# Claude MD Template

Copy this file to your project root as `CLAUDE.md` and customize the sections below.

---

# HPC Development Workflow with Claude Code

## HPC Connection

### SSH Configuration
- **hpc-login**: Default login/gateway node for the cluster
- **hpc-compute**: Current active compute node with interactive job (accessed via ProxyJump through hpc-login)
- **Local command**: `setnode <node-name>` updates hpc-compute SSH config to point to the active compute node

### Checking Current Compute Node
```bash
ssh hpc-login "squeue -u <YOUR_USERNAME>"
```

### Starting New Interactive Job
```bash
ssh hpc-login "interactive"
```
Then run `setnode <new-node>` locally to update SSH config.

## Conda Activation

### Correct Pattern
```bash
#!/bin/bash
#SBATCH directives...

# Activate conda environment
source ~/.bashrc
conda activate <env_name>

# Then run your Python script
python script.py
```

### Incorrect Patterns (Do NOT Use)
```bash
# WRONG - conda run doesn't properly activate the environment
conda run -n <env_name> python script.py

# WRONG - hard-coded conda path may not initialize properly
source /path/to/conda3/bin/activate <env_name>
```

### Why This Matters
Without proper conda activation, scripts will use system Python packages which may have binary incompatibility issues (e.g., `ValueError: numpy.dtype size changed`). Always use `source ~/.bashrc; conda activate <env>` in SLURM scripts.

### Interactive Use
```bash
ssh hpc-compute "source ~/.bashrc && conda activate <env_name> && python script.py"
```

## Development Workflow

### Primary Approach: Local Edit + SCP
1. Edit files locally with Claude Code or your editor
2. Sync changes to HPC using `scp`:
   ```bash
   # Single file
   scp /local/path/file.py hpc-login:/remote/path/

   # Multiple files
   scp /local/path/*.py hpc-login:/remote/path/

   # Recursive directory
   scp -r /local/path/dir/ hpc-login:/remote/path/
   ```
3. Execute jobs via SSH on compute node or submit to SLURM

**Important:** `rsync` is not available on HPC nodes. Always use `scp` for file transfers.

**Important:** Write scripts locally first using the Write tool, then `scp` them to HPC. Do NOT use `cat << EOF` or heredocs over SSH -- this is error-prone and harder to debug.

## SLURM Conventions

### Partition Reference

| Partition  | Max CPUs | Max Time | Use Case |
|------------|----------|----------|----------|
| `quick`    | 16       | 4 hours  | Short preprocessing, testing |
| `ht`       | no cap   | 1 day    | Medium jobs, generation tasks |
| `normal`   | no cap   | 3 days   | Large jobs, full genome processing |
| `infinite` | no cap   | no cap   | Very long running jobs |

**Note:** If requesting >16 CPUs, you must use `normal`, `ht`, or `infinite` (not `quick`).

### Typical sbatch Template
```bash
#!/bin/bash
#SBATCH --job-name=my_job
#SBATCH --partition=quick
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=12G
#SBATCH --time=01:00:00
#SBATCH --output=/path/to/logs/job_%j.out
#SBATCH --error=/path/to/logs/job_%j.err

echo "Job ID: ${SLURM_JOB_ID}"
echo "Node: ${SLURM_NODELIST}"
echo "Start time: $(date)"

source ~/.bashrc
conda activate <env_name>

python my_script.py
```

### Array Jobs
```bash
#SBATCH --array=1-22
CHR=${SLURM_ARRAY_TASK_ID}
echo "Processing chromosome ${CHR}..."
```

### Monitoring Jobs
```bash
# Check all your jobs
ssh hpc-compute "squeue -u <YOUR_USERNAME>"

# Detailed job info
ssh hpc-compute "sacct --format=JobID,JobName,State,Start,Elapsed,ExitCode -u <YOUR_USERNAME> -S now-1hour"

# Tail log output
ssh hpc-compute "tail -f /path/to/logs/job_12345.out"

# Cancel a job
ssh hpc-compute "scancel <job-id>"
```

## Project Organization

All work is organized into numbered project directories under `projects/`:

```
projects/
├── README.md              # Index of all projects
├── 01-project-name/
│   ├── NOTES.md           # Operational details, HPC paths, job history
│   ├── scripts/           # Analysis scripts, SLURM batch files
│   ├── notebooks/         # Marimo notebooks for interactive analysis
│   └── results/           # Symlinks to result directories
├── 02-another-project/
│   └── ...
```

Each project has:
- **`NOTES.md`** -- Operational details: HPC paths, scripts, data formats, job history, pending tasks
- **`scripts/`** -- Analysis scripts, SLURM batch files
- **`notebooks/`** -- Marimo notebooks for interactive analysis
- **`results/`** -- Symlinks to result directories (where applicable)

## Documentation Standards

Three tiers of documentation:

1. **Experiment logs** -- Scientific methodology and results. What question were you asking? What did you find?
2. **Project NOTES.md** -- Operational details. HPC paths, scripts, data formats, job history, pending tasks. This is where Claude Code looks for context.
3. **Results files** -- Actual output data, figures, tables. Stored on HPC, symlinked from project `results/` directory.

Keep scientific narrative separate from operational details.

## Marimo Conventions

[Marimo](https://marimo.io/) is a reactive Python notebook for interactive analysis. Use it instead of standalone plotting scripts when:
- Exploring data interactively (parameter sweeps, filtering)
- Creating visualization dashboards
- Prototyping analysis before writing batch scripts

### File Convention
- Store notebooks in `projects/{project}/notebooks/`
- Name descriptively: `plot_r2_comparison.py`, `explore_pca_variance.py`
- Marimo notebooks are plain `.py` files (not `.ipynb`) -- git-friendly

### Creating and Running
```bash
marimo edit projects/01-project-name/notebooks/my_notebook.py
marimo run projects/01-project-name/notebooks/my_notebook.py
```

---

<!-- Customize: Add your project-specific context below -->
<!-- Examples of what to add here:
  - Your specific conda environments and what they contain
  - Your project-specific data paths on HPC
  - Conventions specific to your research area
  - Any special tools or workflows you use
-->

# Common HPC Errors

A reference for errors you will encounter on the cluster. Each entry follows the pattern: what you see, why it happens, how to fix it, and how to prevent it in the future.

---

## chr1 vs 1 Chromosome Naming

**Symptom:** Your analysis produces no results, zero variants, or an error like "contig not found" or "chromosome mismatch." Tools may silently produce empty output rather than raising an error.

**Cause:** Some datasets use the `chr1, chr2, ...` convention (UCSC-style) while others use `1, 2, ...` (Ensembl-style). When you combine files with different conventions, tools cannot match variants across them.

**How to detect:**

```bash
# Check a VCF file's chromosome naming
bcftools view -h input.vcf.gz | grep "^##contig"

# Or look at the first few data lines
bcftools view input.vcf.gz | head -5

# Check a BED file
head -3 regions.bed
```

**Fix:**

```bash
# Add "chr" prefix to a VCF
bcftools annotate --rename-chrs chr_map.txt input.vcf.gz -Oz -o output.vcf.gz

# Where chr_map.txt contains:
# 1 chr1
# 2 chr2
# ... etc.

# Remove "chr" prefix
sed 's/^chr//' input.vcf > output.vcf
```

**Prevention:** Before combining any two files, check their chromosome naming. Document which convention each dataset uses in [DATA_LOCATIONS.md](DATA_LOCATIONS.md). Standardize early in your pipeline.

---


## SSH Connection Drops

**Symptom:** Your SSH session to a compute node freezes or disconnects after a period of inactivity. Interactive processes running in the foreground are killed.

**Cause:** Network timeouts, firewalls, or idle connection limits terminate inactive SSH sessions.

**Fix (keep connections alive):**

Add to your local `~/.ssh/config`:

```
Host hpc-*
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

This sends a keepalive packet every 60 seconds and drops the connection only after 3 missed responses.

**Fix (survive disconnects):**

Use `screen` or `tmux` on the compute node so your processes continue even if SSH disconnects:

```bash
# Start a new screen session
screen -S my_analysis

# Run your long command inside screen
python long_analysis.py

# Detach: Ctrl+A, then D

# Reattach later
screen -r my_analysis
```

**Prevention:** For any interactive process that takes more than a few minutes, always run it inside `screen` or `tmux`. For anything longer than ~30 minutes, consider submitting as a SLURM batch job instead.

---

## ModuleNotFoundError in SLURM Jobs

**Symptom:**

```
ModuleNotFoundError: No module named 'pandas'
```

or similar, for a package you know is installed in your conda environment.

**Cause:** Your SLURM script is not activating the conda environment, so it uses the system Python which lacks your packages.

**Fix:**

Add these lines to your sbatch script before the Python command:

```bash
source ~/.bashrc
conda activate my_env
```

**How to verify which Python is being used:**

```bash
# Add this to your script for debugging
which python
python -c "import sys; print(sys.prefix)"
```

If the output shows a system path like `/usr/bin/python` instead of your conda env path, conda was not activated.

**Prevention:** Always include `source ~/.bashrc && conda activate <env>` in every SLURM script that runs Python. See [CONDA_ENVIRONMENTS.md](CONDA_ENVIRONMENTS.md) for the full pattern.

---

## SLURM Job Stuck in PD (Pending)

**Symptom:** Your job shows state `PD` in `squeue` and never starts running.

**Cause:** There are several possibilities, and the `REASON` column tells you which one.

**How to diagnose:**

```bash
squeue -u $USER -o "%.18i %.9P %.30j %.8u %.8T %.10M %.6D %R"
```

The last column shows the reason:

| Reason | Meaning | What to Do |
|--------|---------|------------|
| `Resources` | Waiting for nodes to free up | Be patient, or reduce resource requests |
| `Priority` | Other jobs have higher priority | Be patient, or use a less busy partition |
| `QOSMaxCpuPerUserLimit` | You hit your CPU quota | Wait for running jobs to finish, or cancel some |
| `PartitionNodeLimit` | Requested more nodes than partition allows | Reduce `--nodes` |
| `ReqNodeNotAvail` | Requested node is down or reserved | Remove specific node requests |
| `InvalidAccount` | Account/partition issue | Check that you are using a valid partition |

**Fix:**
- For `Resources` or `Priority`: usually just wait. Check how busy the partition is with `squeue -p <partition>`.
- For quota limits: cancel unnecessary jobs or wait for running jobs to finish.
- For `InvalidAccount`: double-check your `--partition` and any `--account` directives.

**Prevention:**
- Request only the resources you need. Overestimating CPUs or memory keeps your job waiting longer.
- Use `quick` for short jobs since it has the fastest turnaround.
- For urgent jobs, check partition load before submitting and choose the least busy option.

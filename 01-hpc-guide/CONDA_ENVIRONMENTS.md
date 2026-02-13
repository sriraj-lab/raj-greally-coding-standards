# Conda Environments on HPC

Conda manages isolated Python (and R) environments with their own package versions. On HPC, proper conda usage is critical because system-level packages can have binary incompatibilities that cause silent data corruption or cryptic crashes.

---

## Why This Matters

Scientific Python packages like numpy, scipy, and pandas include compiled C/Fortran code. These compiled components must be built against compatible versions of each other. When you mix packages from different sources (e.g., system pip and conda), you get errors like:

```
ValueError: numpy.dtype size changed, may indicate binary incompatibility
```

This means your numpy was compiled against a different C header than what pandas or scipy expects. The only reliable fix is a consistent conda environment.

---

## Correct Activation in SLURM Scripts

In a SLURM batch script, conda is not available by default because `.bashrc` is not sourced in non-interactive shells. You must explicitly source it.

**The correct pattern:**

```bash
#!/bin/bash
#SBATCH --job-name=my_job
#SBATCH --partition=quick
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=logs/job_%j.out
#SBATCH --error=logs/job_%j.err

# Activate conda environment — this is the correct way
source ~/.bashrc
conda activate my_env

# Now Python and all packages come from the conda env
python my_script.py
```

**For interactive SSH commands:**

```bash
ssh compute-node "source ~/.bashrc && conda activate my_env && python my_script.py"
```

### Why `source ~/.bashrc` is required

When SLURM runs your script, it starts a non-interactive, non-login shell. Your `.bashrc` contains the `conda init` block that sets up the `conda` command. Without sourcing it, `conda activate` will either fail silently or not be found.

---

## Patterns That Do NOT Work

### `conda run` (do not use)

```bash
# WRONG — conda run does not properly set up the shell environment
conda run -n my_env python my_script.py
```

`conda run` is unreliable in SLURM contexts. It does not fully activate the environment the way `conda activate` does, leading to missing environment variables and path issues.

### Hard-coded conda paths (do not use)

```bash
# WRONG — fragile and may not initialize conda properly
source /path/to/miniconda3/bin/activate my_env
```

This bypasses the `conda init` setup in your `.bashrc` and can lead to incomplete activation, especially when conda's internals change between versions.

### Forgetting activation entirely

```bash
# WRONG — uses system Python, not your environment
python my_script.py
```

This will use whatever Python is on the system `PATH`, which may lack your packages entirely or have incompatible versions.

---

## Creating New Environments

Use **mamba** to create environments. Mamba is a drop-in replacement for conda with a much faster dependency solver.

```bash
# Create a new environment with specific Python version and core packages
mamba create -n my_new_env python=3.10 pandas numpy scipy scikit-learn

# Activate it
conda activate my_new_env
```

### Clean rebuild pattern ("no-cache" behavior)

For timing-critical or clean rebuilds on HPC, use a fresh package cache directory so mamba does not reuse old cached package artifacts.

```bash
# Ensure conda/mamba shell functions are available
source ~/.bashrc

# Fresh cache path for this rebuild/run
export CONDA_PKGS_DIRS="/scratch/tmp/$USER/conda-pkgs-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$CONDA_PKGS_DIRS"

# Create env with mamba
mamba create -n my_new_env python=3.11 numpy pandas scipy scikit-learn

# Activate and install project deps
conda activate my_new_env
cd /path/to/your/repo
uv pip install --python "$(which python)" --no-cache -e ".[dev]"
```

If `uv` warns about hardlink fallbacks across filesystems, set:

```bash
export UV_LINK_MODE=copy
```

### Naming convention

Use descriptive names that reflect the purpose of the environment:

- `local_pca` — for local PCA analysis workflows
- `neural-admixture` — for neural network / admixture modeling
- `variant-calling` — for variant calling pipelines

Avoid generic names like `env1`, `test`, or `myenv`.

### When to create a new environment vs. install into an existing one

**Create a new environment when:**
- You need a conflicting version of a package (e.g., torch 1.x vs 2.x)
- You are starting a substantially different project
- You need a different Python version

**Install into an existing environment when:**
- The new package is compatible with everything already installed
- The project is closely related to the env's purpose

When in doubt, create a new environment. Disk space is cheap; debugging broken environments is not.

---

## Installing Packages

### For pure-Python packages: use `uv pip`

`uv pip` is much faster than regular `pip` and handles resolution well for pure-Python packages.

```bash
conda activate my_env
uv pip install some-package
```

### For compiled/scientific packages: use `mamba`

For packages with C/Fortran extensions (numpy, scipy, torch, cyvcf2, pysam, etc.), prefer mamba to get pre-built binaries that are compatible with each other.

```bash
conda activate my_env
mamba install -c conda-forge cyvcf2 pysam
```

### General rule

- `mamba install` for anything with compiled code or complex binary dependencies
- `uv pip install` for everything else

---

## Exporting and Sharing Environments

To share your environment with a lab member or document it for reproducibility:

```bash
# Export only explicitly requested packages (recommended)
conda env export --from-history > environment.yml

# Recreate the environment on another machine
mamba env create -f environment.yml
```

The `--from-history` flag exports only the packages you explicitly installed, not every transitive dependency. This makes the file portable across platforms (e.g., Linux HPC vs. macOS laptop).

---

## Lab Environments

These environments are available on the cluster. Use them when they fit your needs rather than creating duplicates.

| Environment | Key Packages | Use Case |
|-------------|-------------|----------|
| `local_pca` | pandas, numpy, scipy, scikit-learn | PopGen/PCA workflows, statistical analysis |
| `neural-admixture` | torch 2.6, cyvcf2, numpy, pandas, scipy, pytest | Neural network models, VCF processing |

To check what is installed in an environment:

```bash
conda activate local_pca
conda list
```

---

## Troubleshooting

### `ModuleNotFoundError` in SLURM jobs

Your conda environment was not activated. Add `source ~/.bashrc && conda activate <env>` to your sbatch script. See the [correct activation pattern](#correct-activation-in-slurm-scripts) above.

### `numpy.dtype size changed` or similar binary errors

You are mixing packages from different sources. Reinstall the conflicting packages within a single conda environment:

```bash
conda activate my_env
mamba install numpy pandas scipy  # reinstall from the same channel
```

### `conda activate` says "command not found"

You forgot `source ~/.bashrc`. Conda's `activate` command is a shell function set up by `conda init`, which lives in your `.bashrc`.

### Environment takes forever to solve

Use `mamba` instead of `conda`. If mamba is also slow, you may have conflicting version constraints. Try creating a fresh environment with fewer pinned versions.

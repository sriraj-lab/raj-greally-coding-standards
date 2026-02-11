# Package Management

## Decision Tree

**Do I need a new environment?**
- New project with conflicting dependencies (e.g., different PyTorch version) --> create a new environment
- Adding a package to an existing workflow --> install into the existing environment
- Unsure --> install into existing environment first; create a new one only if there are conflicts

## Tools

| Task | Tool | Example |
|------|------|---------|
| Create environment | `mamba` | `mamba create -n local_pca python=3.11 numpy pandas scikit-learn` |
| Install Python packages | `uv pip` | `uv pip install ruff pytest` |
| Install non-Python deps | `mamba` | `mamba install -n myenv samtools bcftools` |

### Why mamba + uv pip?

- `mamba` resolves conda packages fast and handles compiled dependencies (C libraries, CUDA).
- `uv pip` is faster than `pip` for pure Python packages and respects the active conda environment.

## Rules

1. **Never `pip install` into system Python.** Always activate a conda environment first.
2. **Use descriptive environment names.** `neural-admixture` tells you what it is for. `env1` does not.
3. **One environment per workflow family.** You do not need one per script, but separate environments for separate toolchains (e.g., `local_pca` for PCA work, `neural-admixture` for torch-based models).

## Lock Files

When you need to record the exact environment state (e.g., for a publication or shared analysis):

```bash
conda env export --from-history -n local_pca > environment.yml
```

The `--from-history` flag captures only packages you explicitly installed, not every transitive dependency. This makes the file portable across platforms.

For full reproducibility (same platform only):

```bash
conda env export -n local_pca > environment-lock.yml
```

## Lab-Shared vs Personal Environments

- **Personal environments** live in your home directory. Create and modify freely.
- **Lab-shared environments** (if any) should not be modified without coordination. If you need a package that is not there, either install it in a personal environment or discuss with the team.

## Common Patterns

### Creating an environment for a new project

```bash
mamba create -n my-project python=3.11 numpy pandas scipy
conda activate my-project
uv pip install ruff pytest
```

### Adding a package to an existing environment

```bash
conda activate local_pca
uv pip install new-package
```

### Activating in SLURM scripts

```bash
#!/bin/bash
#SBATCH ...

source ~/.bashrc
conda activate local_pca

python my_script.py
```

Always use `source ~/.bashrc` then `conda activate` in SLURM scripts. Other approaches (`conda run`, hard-coded paths) do not work reliably.

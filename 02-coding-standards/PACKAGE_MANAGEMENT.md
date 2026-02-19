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

## Lab Shared Utility Package (`rajlab_utils`)

Before writing new helpers for common operations (logging, command execution, ID parsing/alignment, genetic-map parsing, VCF helpers, `bcftools`/`plink2`/`regenie` wrappers), check and use `rajlab_utils`. Common sofware tools are also available in `/gs/gsfs0/users/raj-lab/software`. 

- Repo: `git@github.com:sriraj-lab/utilities.git`
- Import path: `rajlab_utils`
- API index: `utilities/docs/API.md` in that repo

### Install Pattern (local)

```bash
conda activate <your-env>
cd /path/to/utilities
python -m pip install -e .
```

### Install Pattern (HPC)

```bash
source ~/.bashrc
conda activate <an-env>
cd /gs/gsfs0/users/raj-lab/software/utilities
python -m pip install -e .
```

If you need to run package tests in that environment:

```bash
python -m pip install -e ".[dev]"
pytest -q
```

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


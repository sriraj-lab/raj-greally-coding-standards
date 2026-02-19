# Git Workflow

## What to Commit

**DO commit to algorithmic packages:**
- Core library/package code (`src/` modules)
- Tests and test data
- Package configuration (`setup.py`, `pyproject.toml`)
- README and package documentation

**DO NOT commit:**
- Analytical scripts (one-off analyses)
- Pipeline/workflow scripts
- SLURM batch scripts (`.sbatch`)
- Plotting/visualization scripts
- One-off data processing scripts

These workflow scripts are ephemeral and project-specific. They belong in experiment logs and project NOTES.md files, not in version-controlled packages.

## .gitignore

Use this as a starting template for computational biology projects:

```gitignore
# Data files - never commit large genomic data
*.vcf
*.vcf.gz
*.vcf.gz.tbi
*.bcf
*.bam
*.bam.bai
*.cram
*.bed
*.bim
*.fam
*.bgen
*.sample
*.pgen
*.pvar
*.psam
*.hdf5
*.h5
*.zarr/

# Results and outputs
results/
output/
*.log

# SLURM
*.sbatch
slurm-*.out
*.err

# Python
__pycache__/
*.pyc
*.pyo
*.egg-info/
dist/
build/
.eggs/

# Environments
.venv/
venv/
*.conda/
.conda/

# OS
.DS_Store
Thumbs.db

# Secrets and credentials
.env
*.pem
*.key
credentials.*
```

Adapt this to your project. When in doubt, add it to `.gitignore`.

## Branching

- `main` is the stable branch. It should always work.
- Create feature branches for new work: `add-projection-protocol`, `fix-pca-centering`.
- Merge into `main` via pull request.
- Delete feature branches after merging.

## Commit Messages

- One line, descriptive: "Fix off-by-one in window boundary calculation"
- If more context is needed, add a blank line then a longer description

Good:
```
Add local PCA projection for out-of-sample variants
```

Bad:
```
updates
```

## When to Commit

Commit at logical checkpoints:
- A function works and its tests pass
- A new feature is complete
- A bug is fixed
- Before making a big change (so you can revert)

Do not wait until everything is "done." Small, frequent commits are easier to review and revert.

## Security

**Never commit tokens, passwords, API keys, or protected health information (PHI).**

If you accidentally commit a secret:
1. **Rotate the credential immediately.** Removing it from git history is not enough -- it may already be exposed.
2. Use `git filter-branch` or `BFG Repo-Cleaner` to remove it from history.
3. Force-push the cleaned history.

Prevention: use `.env` files (which are in `.gitignore`) for credentials. Never hard-code secrets in scripts.

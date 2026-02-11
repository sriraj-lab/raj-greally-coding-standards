# Project Structure

## Numbered Project Directories

Every project lives under `projects/` with a numbered prefix:

```
projects/
  01-data-generation/
  02-single-variant-pheno-comparison/
  03-embedding-reconstruction-quality/
  04-selection-sweep/
  05-ibs-spectral-graph/
```

The number is the creation order. It never changes, even if priorities shift. Use lowercase with hyphens for directory names. Keep them short but descriptive.

## Required Contents Per Project

Every project directory must contain:

| Item | Purpose |
|------|---------|
| `NOTES.md` | Operational record: HPC paths, data formats, job history, pending tasks |
| `scripts/` | Analysis scripts, SLURM batch files |
| `notebooks/` | Marimo notebooks for interactive analysis |
| `results/` | Symlinks to HPC result directories |

Create these when you start a project, not when you "get around to it."

## Example Directory Tree

```
projects/03-embedding-reconstruction-quality/
  NOTES.md
  scripts/
    compute_pca_embeddings.py
    run_pca_all_chromosomes.sbatch
    evaluate_reconstruction.py
  notebooks/
    plot_embedding_reconstruction.py
    explore_pca_variance.py
  results/
    pca-output -> ../../../data/aim2/pca-results/
```

## Naming Conventions

### Directories
- Lowercase, hyphens between words: `local-pca-adjustment/`
- Numbered prefix for top-level projects: `01-data-generation/`

### Scripts
- Lowercase, underscores between words: `compute_pca_embeddings.py`
- Descriptive names that say what the script does, not `run.py` or `process.py`
- SLURM scripts use `.sbatch` extension: `run_pca_all_chromosomes.sbatch`

### Output Files
- Include date or job ID where relevant: `pca_results_2025-01-15.tsv`, `gwas_output_job12345.txt`
- This makes it easy to tell which run produced which file

### Notebooks
- Descriptive prefix indicating purpose: `plot_r2_comparison.py`, `explore_pca_variance.py`

## What Goes Where

### On HPC
- Raw and processed data (VCFs, PGEN, embeddings)
- SLURM scripts and job outputs
- Large intermediate files
- Result directories that `results/` symlinks point to

### Local
- Project directories with NOTES.md, scripts, notebooks
- Package/library source code
- Experiment documentation
- Small test data for development

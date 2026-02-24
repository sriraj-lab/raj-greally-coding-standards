# Reproducibility

## Core Principle

Another lab member should be able to reproduce any analysis using only the documentation. From the docs alone.

## Reproducibility Checklist

Before considering an analysis "done," confirm you have documented:

- [ ] **Input paths** -- where the raw/processed data lives on HPC
- [ ] **Script paths** -- which script was run, its full path
- [ ] **Parameters** -- all non-default arguments, configuration choices
- [ ] **Output paths** -- where results were written
- [ ] **Conda environment** -- which environment was activated
- [ ] **Random seeds** -- if any stochastic step is involved, the seed used
- [ ] **Figure scripts** -- path to the script that generated each figure

This lives in your project's NOTES.md (operational) and experiment docs (scientific).

## Version Pinning for Publications

When preparing results for a paper or presentation:

1. **Export the conda environment:**
   ```bash
   conda env export --from-history -n local_pca > environment.yml
   ```

2. **Record package versions in NOTES.md:**
   ```markdown
   ## Environment for Publication Figures
   - Python 3.11.7
   - numpy 1.26.2
   - scikit-learn 1.3.2
   - pandas 2.1.4
   ```

3. **Tag the commit** (if in a version-controlled package):
   ```bash
   git tag -a v1.0-paper-submission -m "Code state at paper submission"
   ```

## Data Provenance

Document the full chain from raw data to final result. For any output file, you should be able to answer:

1. **Where did the input come from?** (download URL, internal pipeline, collaborator)
2. **What transformations were applied?** (filtering, subsetting, normalization)
3. **What scripts ran on it?** (with parameters)
4. **What environment was used?** (conda env name, key package versions)

### Example Provenance Chain

```
Raw VCF (1000 Genomes Phase 3, downloaded 2024-11-01)
  -> Subset to EUR samples (scripts/subset_by_ancestry.py --pop EUR)
  -> Filter MAF > 0.01 (bcftools view -q 0.01:minor)
  -> Compute PCA (scripts/compute_pca_embeddings.py --n-components 10 --window 1000)
  -> Output: /gs/gsfs0/users/raj-lab/hersh/aim2/pca-results/eur_local_pca.h5
```

This does not need to be formal. A few lines in NOTES.md that trace the path from input to output is sufficient.

## Common Pitfalls

- **Undocumented manual steps.** "I just eyeballed the threshold" is not reproducible. Write down the threshold.
- **Stale paths.** If data moves, update the docs. Old paths that point nowhere help no one.
- **Missing seeds.** If you do not set a random seed, your results may differ on re-run. Always set and document seeds for stochastic analyses.

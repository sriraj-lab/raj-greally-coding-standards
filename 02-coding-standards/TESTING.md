# Testing

This is not about 100% coverage. It is about catching bugs before you waste hours of HPC time on a job that fails at step 47.

## Two Levels

### 1. Smoke Tests: Does It Run?

Before submitting a full-genome SLURM job, run your script on a tiny input and check that it completes without errors.

```bash
# Subset your VCF to 100 variants
bcftools view -r chr1:1-100000 full.vcf.gz -Oz -o test_tiny.vcf.gz

# Run your script on it
python compute_embeddings.py --input test_tiny.vcf.gz --output test_out.tsv

# Check the output looks right
head test_out.tsv
wc -l test_out.tsv
```

This takes 30 seconds and saves you from discovering a typo after waiting an hour in the SLURM queue.

### 2. Unit Tests: Does the Logic Work?

For reusable packages and libraries, write proper tests with pytest.

```python
# tests/test_embedding.py
import numpy as np
from local_pca.embedding import compute_embeddings


def test_output_shape():
    genotypes = np.random.randint(0, 3, size=(50, 200))
    result = compute_embeddings(genotypes, window_size=100, n_components=5)
    assert result.shape == (50, 2, 5)


def test_handles_missing_data():
    genotypes = np.full((10, 50), np.nan)
    genotypes[:, :25] = np.random.randint(0, 3, size=(10, 25))
    result = compute_embeddings(genotypes, window_size=50, n_components=3)
    assert not np.any(np.isnan(result))
```

Run with:

```bash
pytest tests/ -v
```

## The Genomics Testing Pattern

Most genomics scripts follow the same testing pattern:

1. **Create a tiny test dataset** -- a few hundred variants, a handful of samples
2. **Run the script** on the tiny dataset
3. **Check the output:**
   - Does the file exist?
   - Is the format correct (right columns, right delimiters)?
   - Are the dimensions correct (right number of rows/columns)?
   - Are the values in a reasonable range?

This is your minimum bar before any SLURM submission.

## When to Test

- **Before a full-genome SLURM job.** Always smoke test first.
- **Before changing core package code.** Run the test suite.
- **When debugging.** Write a test that reproduces the bug, then fix it.
- **After changing dependencies.** A quick `pytest` run catches binary incompatibilities early.

## Test Data

- Keep small test files in `tests/data/` within your package.
- These files should be small enough to commit to git (under a few MB).
- Never commit full datasets. Generate or subset test data programmatically when possible.

```
my-package/
  src/
  tests/
    data/
      tiny_genotypes.vcf.gz    # 100 variants, 10 samples
      expected_output.tsv
    test_embedding.py
    test_io.py
```

# Python Style

Keep style overhead low. Let automated tools handle formatting so you can focus on science.

## Use ruff

[ruff](https://docs.astral.sh/ruff/) handles both linting and formatting. Add this to your `pyproject.toml`:

```toml
[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "W"]

[tool.ruff.format]
quote-style = "double"
```

Run before committing:

```bash
ruff check --fix .
ruff format .
```

## Naming

| Thing | Convention | Example |
|-------|-----------|---------|
| Functions, variables | `snake_case` | `compute_pca`, `sample_ids` |
| Classes | `PascalCase` | `VcfReader`, `PhenotypeModel` |
| Constants | `UPPER_CASE` | `MAX_ITERATIONS`, `DEFAULT_WINDOW_SIZE` |
| Files | `snake_case` | `compute_pca_embeddings.py` |

## Docstrings

Use Google style. Required for any function longer than 10 lines.

```python
def compute_local_pca(genotypes, window_size, n_components=10):
    """Compute PCA within a sliding window along the genome.

    Args:
        genotypes: Array of shape (n_samples, n_variants).
        window_size: Number of variants per window.
        n_components: Number of PCs to retain.

    Returns:
        Array of shape (n_samples, n_windows, n_components).
    """
```

## Type Hints

Encouraged everywhere. Required for public API functions in packages.

```python
def load_sample_ids(vcf_path: str) -> list[str]:
    ...
```

## Imports

Order: standard library, third-party, local. Ruff handles sorting automatically.

```python
import os
from pathlib import Path

import numpy as np
import pandas as pd

from local_pca.embedding import compute_embeddings
```

## Guidelines

- **Max function length:** ~50 lines. If it is longer, break it up.
- **Avoid global state.** Pass data through function arguments.
- **No mutable default arguments.** Use `None` and assign inside the function.
- **No bare `except`.** Catch specific exceptions.
- **No `import *`.** Always import specific names.

## Script Structure

Every runnable script should have a `main()` function with argument parsing:

```python
import argparse


def main():
    parser = argparse.ArgumentParser(description="Compute PCA embeddings")
    parser.add_argument("--input", required=True, help="Path to input VCF")
    parser.add_argument("--output", required=True, help="Path to output file")
    parser.add_argument("--n-components", type=int, default=10)
    args = parser.parse_args()

    # Do the work
    ...


if __name__ == "__main__":
    main()
```

This makes scripts testable, importable, and self-documenting.

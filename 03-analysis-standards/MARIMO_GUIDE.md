# Marimo Notebooks

## What Is Marimo?

[Marimo](https://marimo.io/) is a reactive Python notebook. Unlike Jupyter, marimo notebooks are plain `.py` files, which means they diff cleanly in git and do not accumulate stale output. Cells re-execute automatically when their dependencies change, so you cannot have out-of-order execution bugs.

## When to Use Marimo vs a Script

**Use marimo when:**
- Exploring data interactively (trying different filters, thresholds, parameters)
- Building visualization dashboards with sliders and dropdowns
- Prototyping an analysis before writing a batch script

**Use a plain script when:**
- Running a batch job on HPC
- The analysis is finalized and does not need interaction
- You need argparse arguments or SLURM integration

**Rule of thumb:** Start in marimo for exploration. Once the analysis is stable, extract the core logic into a script.

## File Conventions

- Store notebooks in `projects/{project}/notebooks/`
- Name with a descriptive prefix indicating purpose:
  - `plot_r2_comparison.py`
  - `explore_pca_variance.py`
  - `dashboard_phenotype_results.py`
- Marimo notebooks are plain `.py` files, not `.ipynb`. They are git-friendly.

## Basic Structure

A typical marimo notebook follows this pattern:

```python
import marimo

app = marimo.App()


@app.cell
def imports():
    import marimo as mo
    import pandas as pd
    import numpy as np
    import altair as alt
    return alt, mo, np, pd


@app.cell
def load_data(pd):
    df = pd.read_csv("/path/to/results.tsv", sep="\t")
    return (df,)


@app.cell
def controls(mo):
    chromosome = mo.ui.dropdown(
        options=[str(i) for i in range(1, 23)],
        value="1",
        label="Chromosome",
    )
    n_components = mo.ui.slider(1, 20, value=10, label="PCs")
    mo.hstack([chromosome, n_components])
    return chromosome, n_components


@app.cell
def visualize(alt, chromosome, df, n_components):
    filtered = df[
        (df["chromosome"] == int(chromosome.value))
        & (df["n_pcs"] == n_components.value)
    ]
    chart = (
        alt.Chart(filtered)
        .mark_point()
        .encode(x="position", y="r2", color="method")
    )
    chart
    return


if __name__ == "__main__":
    app.run()
```

## How to Run

```bash
# Development mode (edit cells, see reactive updates)
marimo edit projects/03-embedding-reconstruction-quality/notebooks/plot_embedding_reconstruction.py

# Presentation mode (read-only, clean layout)
marimo run projects/03-embedding-reconstruction-quality/notebooks/plot_embedding_reconstruction.py
```

- Use `marimo edit` when building or modifying the notebook.
- Use `marimo run` when presenting results or sharing with others.

## Tips

- **Extract finalized analysis into scripts.** Once you have settled on parameters and logic, move the core computation out of the notebook and into a standalone script. The notebook then becomes a thin visualization layer.
- **Keep notebooks focused.** One notebook per analysis question. Do not build a single notebook that does everything.
- **Use `mo.ui` for parameters.** Sliders, dropdowns, and text inputs make it easy to explore parameter spaces without editing code.

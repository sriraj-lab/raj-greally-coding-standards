# Project AGENTS.md / NOTES.md Template

Copy this template into your project directory as `NOTES.md` (operational log) or `AGENTS.md` (AI context file). Fill in each section as you work.

---

# Project: [Project Name]

## Overview

[1-2 sentences describing this project's goal and approach.]

## Key Paths

| Resource | Path |
|----------|------|
| Input data | `/gs/gsfs0/users/raj-lab/<YOUR_USERNAME>/...` |
| Output/results | `/gs/gsfs0/users/raj-lab/<YOUR_USERNAME>/...` |
| Scripts | `/gs/gsfs0/users/raj-lab/<YOUR_USERNAME>/.../scripts/` |
| Logs | `/gs/gsfs0/users/raj-lab/<YOUR_USERNAME>/.../logs/` |
| Local project dir | `/Users/<YOUR_USERNAME>/work/raj-lab/.../projects/NN-project-name/` |

## Environment

- **Conda environment:** `<env_name>`
- **Key dependencies:** pandas, numpy, scikit-learn, ... (list non-obvious ones)
- **Special setup notes:** [Any environment quirks, version pins, etc.]

## Scripts Inventory

| Script | Description |
|--------|-------------|
| `scripts/run_analysis.py` | Main analysis pipeline |
| `scripts/process_input.py` | Preprocesses raw input data |
| `scripts/plot_results.py` | Generates figures for results |
| `scripts/submit_jobs.sbatch` | SLURM batch script for full run |

## Job History

Track SLURM jobs and their outcomes here.

| Date | Job ID | Script | Status | Notes |
|------|--------|--------|--------|-------|
| YYYY-MM-DD | 123456 | run_analysis.sbatch | COMPLETED | Initial run, 22 chromosomes |
| YYYY-MM-DD | 123457 | run_analysis.sbatch | FAILED | OOM on chr1, increased mem to 100G |

## Pending Tasks

- [ ] Task description (added YYYY-MM-DD)
- [ ] Another task

## Debugging Notes

Document known issues and workarounds:

- **Issue:** [Description of problem]
  - **Workaround:** [How to fix or avoid it]
  - **Status:** Open / Resolved

## Data Provenance

- **Source data:** [Where the input data came from, any accession numbers]
- **Processing applied:** [What transformations were applied before this project's analysis]
- **Sample counts:** [Number of samples, variants, etc.]
- **Reference genome:** [hg19/hg38/etc.]

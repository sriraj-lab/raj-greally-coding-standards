# Documentation

## Three-Tier System

Documentation serves three distinct purposes. Mixing them together makes everything harder to find.

### Tier 1: Logs (NOTES.md Job History Section)

**What:** Operational record of what was run, when, and whether it worked.

This is the "lab notebook" for computation. Write it as you go.

**Example:**

```markdown
## Job History

### 2025-01-15: PCA embedding generation
- **Job ID:** 4523891
- **Script:** `scripts/compute_pca_embeddings.py`
- **Command:** `sbatch scripts/run_pca_all_chromosomes.sbatch`
- **Status:** Completed (22/22 chromosomes)
- **Output:** `/gs/gsfs0/users/raj-lab/hersh/aim2/pca-results/`
- **Notes:** chr6 took 3x longer than other chromosomes (MHC region)

### 2025-01-14: VCF subsetting
- **Job ID:** 4523512
- **Script:** `scripts/subset_vcf_by_ancestry.py`
- **Status:** Failed - OOM on chr1 with 8G/CPU, resubmitted with 16G
- **Resubmit Job ID:** 4523520
- **Status:** Completed
```

### Tier 2: Notes (NOTES.md Main Body)

**What:** Debugging info, gotchas, parameter choices, file paths, data format descriptions.

This is the knowledge that saves you (or a lab mate) from repeating the same mistakes.

**Example:**

```markdown
## Data Format

Sample IDs in VCFs use the format `SAMPLE_001` (zero-padded).
The phenotype file uses `SAMPLE_1` (no padding).
Use `scripts/harmonize_ids.py` to convert between them.

## Gotchas

- bcftools sort requires the full file to fit in memory. For whole-genome
  VCFs, use `--max-mem 40G` or sort per-chromosome first.
- The BGEN files from UK Biobank use 1-based chromosome numbering
  but our VCFs use "chr1" format. Convert with `scripts/fix_chr_prefix.py`.

## Parameter Choices

- Window size: 1000 variants. Chosen based on LD decay in EUR
  (see projects/03-embedding-reconstruction-quality/NOTES.md).
- PCA components: 10 per window. Captures >95% variance in test runs.
```

### Tier 3: Results (Experiment Documentation)

**What:** Scientific findings only. The "Results" section of a paper.

Kept in the experiment documentation directory, separate from operational notes.

**Example:**

```markdown
## Embedding Transfer Across Ancestries

### Scientific Question
Do PCA embeddings trained on EUR samples capture meaningful
genetic structure when applied to AFR samples?

### Results
Projection of AFR samples into EUR-trained PCA space preserves
local LD structure (mean r2 correlation: 0.87) but introduces
systematic bias in PC3+ (see Figure 2).

### Figures
- Figure 1: `scripts/plot_r2_comparison.py`
- Figure 2: `scripts/plot_pc_bias.py`
```

## Rules

1. **Every figure-generating script must be documented.** If you cannot find the script that made a figure, the figure is not reproducible.

2. **Write docs as you go, not after.** "I'll document it later" means "I will forget the details." Add a NOTES.md entry the same day you run the job.

3. **Keep the tiers separate.** Job logs do not belong in experiment results. Parameter choices do not belong in job history. If you are not sure where something goes, it is probably a Tier 2 note.

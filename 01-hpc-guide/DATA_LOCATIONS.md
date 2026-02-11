# Shared Data Locations

This document tracks shared datasets, reference files, and tools on the cluster. If you download or generate a new reference dataset for shared use, add it here via pull request.

---

## How to Read This Document

Each entry follows this format:

- **Path:** Full HPC path
- **Description:** What the data is and how to use it
- **Genome build:** hg19 / hg38 / T2T / N/A
- **Last updated:** Date of last download or update
- **Contact:** Who to ask about this data

Entries marked `TO_FILL` need a lab member to supply the actual path or details.

---

## Reference Genomes

### hg19 (GRCh37)

- **Path:** `TO_FILL`
- **Description:** Human reference genome, GRCh37/hg19 build. FASTA + index files.
- **Genome build:** hg19
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

### hg38 (GRCh38)

- **Path:** `TO_FILL`
- **Description:** Human reference genome, GRCh38/hg38 build. FASTA + index files.
- **Genome build:** hg38
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

### T2T (CHM13)

- **Path:** `TO_FILL`
- **Description:** Telomere-to-Telomere reference genome (CHM13). FASTA + index files.
- **Genome build:** T2T-CHM13
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

---

## Reference Panels

### 1000 Genomes Project

- **Path:** `TO_FILL`
- **Description:** Phase 3 variant calls for 2,504 individuals across 26 populations. VCF files per chromosome.
- **Genome build:** `TO_FILL` (hg19 or hg38 — specify which is available)
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`
- **Notes:** Watch for chromosome naming convention (chr1 vs 1). See [COMMON_ERRORS.md](COMMON_ERRORS.md) for details.

### HGDP (Human Genome Diversity Project)

- **Path:** `TO_FILL`
- **Description:** Genome-wide variant data for diverse human populations.
- **Genome build:** `TO_FILL`
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

### SGDP (Simons Genome Diversity Project)

- **Path:** `TO_FILL`
- **Description:** High-coverage whole genomes from globally diverse populations.
- **Genome build:** `TO_FILL`
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

---

## Common Annotations

### dbSNP

- **Path:** `TO_FILL`
- **Description:** NCBI database of single nucleotide polymorphisms. VCF format.
- **Version:** `TO_FILL`
- **Genome build:** `TO_FILL`
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

### ClinVar

- **Path:** `TO_FILL`
- **Description:** NCBI database of clinically relevant variants. VCF format.
- **Version:** `TO_FILL`
- **Genome build:** `TO_FILL`
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

### ANNOVAR Databases

- **Path:** `TO_FILL`
- **Description:** ANNOVAR annotation databases (refGene, gnomAD, etc.).
- **Genome build:** `TO_FILL`
- **Last updated:** `TO_FILL`
- **Contact:** `TO_FILL`

---

## Shared Tools and Software

Base path: `/gs/gsfs0/users/raj-lab/software/`

| Tool | Path | Version | Description |
|------|------|---------|-------------|
| `TO_FILL` | `/gs/gsfs0/users/raj-lab/software/TO_FILL` | `TO_FILL` | `TO_FILL` |
| `TO_FILL` | `/gs/gsfs0/users/raj-lab/software/TO_FILL` | `TO_FILL` | `TO_FILL` |
| `TO_FILL` | `/gs/gsfs0/users/raj-lab/software/TO_FILL` | `TO_FILL` | `TO_FILL` |

Add rows as you install shared tools.

---

## Biobank Data

### UK Biobank

- **Path:** `TO_FILL`
- **Description:** Genotype and phenotype data for ~500K participants.
- **Access:** Requires approved application. Contact `TO_FILL` for the lab's project ID and access instructions.
- **Genome build:** `TO_FILL`
- **Notes:** `TO_FILL` (e.g., which fields are downloaded, imputed vs. directly genotyped)

### All of Us

- **Path:** `TO_FILL`
- **Description:** NIH research program data. Accessed via the Researcher Workbench.
- **Access:** Requires institutional registration and data use agreement. Contact `TO_FILL` for onboarding instructions.
- **Genome build:** `TO_FILL`
- **Notes:** `TO_FILL`

---

## Contributing

If you download a new reference dataset, annotation, or tool for shared use:

1. Add an entry to the appropriate section above following the standard format.
2. Open a pull request with your additions.
3. Include the genome build, download date, and source URL in your PR description.

This keeps the lab from having multiple redundant copies of large datasets and ensures everyone knows where to find things.

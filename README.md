# Raj-Greally Lab Coding Standards

These standards exist to make computational research in the lab reproducible, collaborative, and safe — whether you're writing your first bash command or building GPU-accelerated pipelines. They cover everything from day-one HPC setup to advanced AI-assisted development, and they're written to be read by someone who might have no prior coding experience.

## How to Use This Repo

1. **Clone this repo** to your local machine
2. **Read [00-quickstart/DAY_ONE.md](00-quickstart/DAY_ONE.md)** and follow the setup instructions
3. **Complete the [first-week project](00-quickstart/FIRST_WEEK_PROJECT.md)** — this is your onboarding assessment
4. **Use the rest as reference** — come back to specific sections when you need them

## Sections

### [00 — Quickstart](00-quickstart/)
Everything you need on day one: SSH setup, your first `.bashrc`, and a structured first-week project that takes you from zero to submitting SLURM jobs and pushing to GitHub.

### [01 — HPC Guide](01-hpc-guide/)
How to use the Einstein HPC cluster: SLURM basics (partitions, sbatch, array jobs), conda environment management, shared data locations, and a troubleshooting guide for common errors.

### [02 — Coding Standards](02-coding-standards/)
How we organize projects, write Python, use git, manage packages, and test our code. These conventions keep the lab's computational work consistent and maintainable.

### [03 — Analysis Standards](03-analysis-standards/)
How we document our work (the three-tier system: logs, notes, results), ensure reproducibility, and use marimo notebooks for interactive analysis.

### [04 — AI Development](04-ai-development/)
Our AI usage policy (a tiered autonomy system from learning mode to full agentic workflows), starter templates for `claude.md` and per-project agent files, and recommended tools.

### [Templates](templates/)
Ready-to-copy files: starter `.bashrc`, SSH config, sbatch template, `.gitignore`, `claude.md` template, and project notes template.

### [Checklists](checklists/)
Onboarding checklists for mentors: one for new lab members, one (abbreviated) for rotation students.

## Philosophy

- **Start simple.** New members begin with bash and SLURM before touching AI tools.
- **Document everything.** If another lab member can't reproduce your result from your notes alone, the documentation is incomplete.
- **AI is a tool, not a crutch.** You must understand code before you run it, whether you wrote it or an AI did.
- **These are living documents.** If something is wrong, outdated, or missing — open a PR.

## For New Members

Start here: **[Day One Setup](00-quickstart/DAY_ONE.md)**

Your mentor will walk you through the setup on your first day. By the end of your first week, you should have completed the [first-week project](00-quickstart/FIRST_WEEK_PROJECT.md) and be comfortable with SSH, bash, SLURM, and git.

## For Mentors

See the [onboarding checklists](checklists/) for what to prepare before a new member arrives and what to review during their first month.

---

*Originally generated: 2026-02-11*
*Last updated: 2026-02-11*

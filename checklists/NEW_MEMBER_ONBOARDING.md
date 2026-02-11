# New Member Onboarding Checklist

This checklist is for mentors and PIs onboarding a new lab member (graduate student, postdoc, or research staff). Work through it together with the new member.

## Before Arrival

- [ ] Request HPC account (TO_FILL: link to account request form)
- [ ] Add to lab GitHub organization
- [ ] Add to lab communication channels (Slack, email lists, etc.)
- [ ] Assign initial project directory number (next available in `projects/`)
- [ ] Prepare any datasets or access permissions they'll need

## Day 1

- [ ] Walk through `00-quickstart/DAY_ONE.md` together
- [ ] Verify SSH access to HPC works (both login and compute nodes)
- [ ] Verify `setnode` function works for compute node switching
- [ ] Introduce lab filesystem layout and data locations on HPC
- [ ] Show how to start an interactive job and run a simple command
- [ ] Explain the project directory structure (`projects/NN-name/`)
- [ ] Assign first-week project (a small, well-defined task to build familiarity)

## Week 1

- [ ] Review first-week project output together
- [ ] Assess coding proficiency level
- [ ] Assign AI autonomy tier (see `04-ai-development/AI_POLICY.md`)
  - Most new members start at Tier 0 or Tier 1
  - Those with prior computational experience may start at Tier 1 or 2
- [ ] If Tier 2+: help set up `claude.md` using the template in `04-ai-development/CLAUDE_MD_TEMPLATE.md`
- [ ] Review coding standards together (`02-coding-standards/`)
- [ ] Review analysis standards (`03-analysis-standards/`)
- [ ] Ensure they understand the documentation tiers (experiment logs, NOTES.md, results)

## Month 1

- [ ] Review first analysis for documentation standards compliance
  - Does the project have a NOTES.md with operational details?
  - Are scripts documented and organized?
  - Is there a clear scientific question or explicit technical label?
- [ ] Check git usage: are they committing regularly? Using .gitignore?
- [ ] Reassess AI tier if needed (move up or down based on observed proficiency)
- [ ] Review any SLURM scripts they've written for best practices
- [ ] Verify they know how to find and use lab templates (`templates/`)

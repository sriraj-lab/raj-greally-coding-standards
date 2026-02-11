# Rotation Student Onboarding Checklist

Abbreviated onboarding for rotation students (typically 6-12 weeks). Focus is on getting productive quickly with a concrete, well-scoped project.

## Before Arrival

- [ ] Request HPC account (TO_FILL: link to account request form) -- start early, accounts can take time
- [ ] Add to lab GitHub organization
- [ ] Add to lab Slack/communication channels
- [ ] Define rotation project scope (one clear deliverable)

## Day 1

- [ ] Walk through `00-quickstart/DAY_ONE.md` together
- [ ] Verify SSH access works
- [ ] Show them how to start an interactive job
- [ ] Introduce their specific project data and directory
- [ ] Pair them with a senior lab member as a day-to-day contact

## Week 1

- [ ] Verify they can: SSH in, submit a test SLURM job, navigate the filesystem
- [ ] Walk through the specific pipeline or tools they'll use for their project
- [ ] Assign AI tier:
  - **Default:** Tier 0 (learning mode) or Tier 1 (assisted coding)
  - **Exception:** Tier 2 if they have strong prior computational experience and demonstrate it
- [ ] Make sure they have a working conda environment for their project
- [ ] Set up their project directory (`projects/NN-rotation-project/`) with NOTES.md

## Ongoing (Weeks 2-12)

- [ ] Weekly check-ins on progress and blockers
- [ ] Review code and documentation at least once mid-rotation
- [ ] Ensure they're documenting what they do (NOTES.md at minimum)

## End of Rotation

- [ ] Deliverable: documented mini-project with reproducible results
  - Scripts are in the project `scripts/` directory
  - NOTES.md has operational details (paths, how to re-run, key parameters)
  - Results are clearly identified and described
- [ ] Handoff: another lab member should be able to reproduce results from the documentation alone
- [ ] If the rotation becomes a longer-term project, transition to the full onboarding checklist

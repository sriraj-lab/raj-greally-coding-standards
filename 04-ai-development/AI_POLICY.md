# AI Development Policy

AI tools like Claude, ChatGPT, and Cursor are powerful accelerators for computational research. They are also capable of producing plausible-looking code that is subtly wrong. These policies exist to help you use AI effectively while maintaining scientific rigor. 

Knowledge checks for tiers are self-judged tiers. Please be resposible- incorrect or irreproducible code is **YOUR PROBLEM** and Sri/John's. Do not go beyond your capabilities. These checks are not exhausitve and are meant to provide a general skill-level check.  

## Autonomy Tiers

### Tier 0 -- Learning Mode

**Who:** Anyone, no prerequisites.

**Allowed uses:**
- Explaining concepts, algorithms, and documentation
- Debugging error messages (paste the error, ask what it means)
  - Writing a few lines of code to get around an error. **YOU MUST UNDERSTAND THE PROBLEM/FIX**
- Understanding unfamiliar syntax or library APIs
- Learning new tools (git, SLURM, conda, hail, etc.)
- Writing plotting code **ONLY**

**Not allowed:**
- Generating large blocks of new codes, particularly algortihmic functions
- Debugging without any form of understanding the error
  - give someone a fish, they don't go hungry for a day; teach someone how to fish, they don't go hungry for the rest of their lives-vibes


**Rationale:** AI is an excellent teacher. There is no risk from reading explanations, and this builds the foundational understanding needed for higher tiers.

---

### Tier 1 -- Assisted Coding

**Who:** Lab members who have passed the first-week project.

**Allowed uses:**
- Generating code snippets that you fully understand and can explain line by line
- Getting help with boilerplate (argparse, file I/O patterns)
- Code review assistance (paste your code, ask for feedback)
- Asking for alternative implementations of code you've already written

**Not allowed:**
- Using agentic tools (Claude Code, Cursor agent mode, Copilot chat with file editing)
- Running AI-generated code without manually reading every line first
- Generating entire scripts or pipelines end-to-end

**Requirement:** If you cannot explain what every line of the generated code does, you are not ready for this tier.

**Knowledge Check:** Core Linux competencies, basic bioinformatics tool usage
- [ ] Know how to navigate a file system using just terminal
- [ ] Examining files in terminal and being able to extract useful information
- [ ] Understanding of VCF and/or SAM/BAM/CRAM, depending on project
- [ ] Setting up a new conda/python environment
- [ ] Basic understanding of SSH to HPC, knowledge of HPC modules
- [ ] Most basic git workflow: single branch, add, commit, push

**Rationale:** You need a baseline of competence to evaluate whether AI output is correct. AI-generated code that looks right but has subtle bugs is more dangerous than obviously broken code.

---

### Tier 2 -- Supervised Agentic

**Who:** Lab members who have demonstrated independent coding proficiency. You can code easily without AI but provides massive speed boost. 

**Allowed uses:**
- Claude Code, Cursor agent mode, and similar agentic AI tools
- AI-assisted refactoring and code generation
- AI-assisted documentation writing

**Not allowed:**
- Zero-shotting entire packages or complex scripts/functions
- Zero-shotting critical analysis for publication. **PLEASE CHECK ANY ANALYSIS IS CORRECT**

**Requirements:**
- Must have a `claude.md` (or equivalent) configuration file for your project
- Must review all AI-generated code before committing
- Must not allow AI to submit SLURM jobs without manual review of the batch script
- Can write working code independently (AI is a productivity boost, not a crutch)

**Knowledge Check:** Proficient with bioinformatics tools, command of HPC tools, core software development documentaion understanding
- [ ] Know when to use which bioinformatics tools. For instance, plink vs plink2 vs bcftools or *FILL-IN*
- [ ] Launch HPC array jobs; complex sbatch scripts (not just load module, run script)
- [ ] Basic understanding of unittests, smoke tests, and pilot tests: purpose and when to use each.
- [ ] Documentation loop
  - This can be customized to your preference but **IT MUST EXIST**
  - More complex git understanding- multiple branches to iterate on code
- [ ] Able to understand boilerplate code in rajlab_utils- why does it work, what's its purpose, etc.
- [ ] Basic understanding of how to orthogonally validate agentic-generated code. 

**Rationale:** Agentic tools can edit files and run commands on your behalf. You need enough experience to catch when they do something wrong, and enough discipline to always review before executing.

---

### Tier 3 -- Full Agentic

**Who:** Advanced users with deep experience in the lab's workflows. You are someone who can code almost anything without hand-holding.  

**Allowed uses:**
- Full AI-assisted workflows including SLURM submission
- Multi-file refactoring and pipeline construction
- AI-driven exploration and prototyping

**Requirements:**
- Highest level of documentation standards must be enforced (NOTES.md, experiment logs, etc.)
- Project-level `AGENTS.md` files describing AI context for each project
- Must be able to debug AI-generated code without AI assistance
- Must maintain clear provenance of what AI generated vs. what you wrote

**Knowledge Check:** Deep understanding of bioinformatics tools (eg, underlying algorithmic design, usage cases), understanding of all critical lab workspaces (local, cloud, HPC, etc), proficient in software development, proficient in computer science principles
- [ ] **Most important: ability to shape a zero-shotted package/pipeline**. You must understand:
  - [ ] Inputs, including configuration
  - [ ] Outputs, including clean data structuring of outputs
  - [ ] Profiling of CPU/memory (mostly for large-scale analyses; see checks below)
  - [ ] **CRITICAL:** Orthogonal validation of new, production-level code that is producing new data and is not just analytical or based on derived data. *IF YOU CANNOT DO THIS, DO NOT USE AGENTS FOR ZERO-SHOT CAPABILITIES*. This includes:
    - [ ] Biological controls - do we find known positive/negatives, how would we test for them?
    - [ ] Technical controls - this code does something similar to older code. Do we get the same answer within reason?
- [ ] Computational knowledge:
  - [ ] Typing - why is this important? Example: Can you explain why VCFs are a bad format for the info they store?
  - [ ] OOP principles - abstraction, class reusage.
  - [ ] Multithreading/parallelism- can you effectively parallelize a workflow? *THIS MAY BE LESS IMPORTANT FOR SOME PROJECTS BUT IF YOU WORK WITH LARGE-SCALE DATA, THIS IS A CORE COMPETENCY*
  - [ ] Memory profiling/understanding - Same note as above
- [ ] Be able to take a birdseye view and critically understand what gates must be reached for code to be considered sufficient.
  - [ ] You can use a small test case to iterate over the cloud using agentic tools without access to HPC/local usage
- [ ] Package management - thorough enough to create production code
- [ ] If you are unsure if you are ready for this, read through population-amplifier and if you cannot understand the design choices, you are probably not ready. 

**Rationale:** Maximum productivity comes with maximum responsibility. At this tier, AI is deeply integrated into your workflow, so documentation and review discipline are critical.

---

## Universal Rules (All Tiers)

These rules apply regardless of your tier level:

1. **Never paste PHI or restricted data into cloud AI.** This includes patient identifiers, restricted-access genotype data, or anything covered by IRB/DUA agreements. If in doubt, ask.

2. **Never commit AI-generated code you don't understand.** If you can't explain it, you can't debug it, and you can't defend it in a paper.

3. **AI code receives the same review standards as human code.** It gets reviewed, tested, and documented the same way. "The AI wrote it" is not an excuse for skipping review.

4. **Verify AI methodological suggestions independently.** If AI suggests a statistical method, a normalization approach, or a biological interpretation, verify it against primary sources (papers, textbooks, documentation). AI confidently hallucinates methodological advice.

5. **Attribute AI contributions.** If AI meaningfully shapes your methodology or analysis approach (not just syntax help), document this in your project's NOTES.md. Example: "Used Claude to design the cross-validation strategy for ancestry-stratified evaluation."

## Moving Between Tiers

Tier assignment is a conversation with your mentor, not a rigid gate. Consider:

- **Moving up:** You've demonstrated competence at your current tier and are ready for more autonomy. Discuss with your mentor.
- **Moving down:** If you find yourself unable to debug AI output, or if AI-generated code introduces bugs you didn't catch, step back to a lower tier temporarily. This is not a punishment -- it's good scientific practice.
- **Project-specific tiers:** You might be Tier 2 for Python analysis scripts but Tier 1 for shell scripting if you're less experienced there. Tiers can vary by domain.

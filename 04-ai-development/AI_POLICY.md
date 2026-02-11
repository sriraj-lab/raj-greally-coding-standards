# AI Development Policy

AI tools like Claude, ChatGPT, and Cursor are powerful accelerators for computational research. They are also capable of producing plausible-looking code that is subtly wrong. These policies exist to help you use AI effectively while maintaining scientific rigor.

## Autonomy Tiers

### Tier 0 -- Learning Mode

**Who:** Anyone, no prerequisites.

**Allowed uses:**
- Explaining concepts, algorithms, and documentation
- Debugging error messages (paste the error, ask what it means)
- Understanding unfamiliar syntax or library APIs
- Learning new tools (git, SLURM, conda, etc.)

**Not allowed:**
- Generating code to run on data
- Writing or modifying scripts
- Any code that will be executed

**Rationale:** AI is an excellent teacher. There is no risk from reading explanations, and this builds the foundational understanding needed for higher tiers.

---

### Tier 1 -- Assisted Coding

**Who:** Lab members who have passed the first-week project.

**Allowed uses:**
- Generating code snippets that you fully understand and can explain line by line
- Getting help with boilerplate (argparse, file I/O patterns, plotting templates)
- Code review assistance (paste your code, ask for feedback)
- Asking for alternative implementations of code you've already written

**Not allowed:**
- Using agentic tools (Claude Code, Cursor agent mode, Copilot chat with file editing)
- Running AI-generated code without manually reading every line first
- Generating entire scripts or pipelines end-to-end

**Requirement:** If you cannot explain what every line of the generated code does, you are not ready for this tier.

**Rationale:** You need a baseline of competence to evaluate whether AI output is correct. AI-generated code that looks right but has subtle bugs is more dangerous than obviously broken code.

---

### Tier 2 -- Supervised Agentic

**Who:** Lab members who have demonstrated independent coding proficiency, with mentor approval.

**Allowed uses:**
- Claude Code, Cursor agent mode, and similar agentic AI tools
- AI-assisted refactoring and code generation
- AI-assisted documentation writing

**Requirements:**
- Must have a `claude.md` (or equivalent) configuration file for your project
- Must review all AI-generated code before committing
- Must not allow AI to submit SLURM jobs without manual review of the batch script
- Can write working code independently (AI is a productivity boost, not a crutch)
- Mentor sign-off required

**Rationale:** Agentic tools can edit files and run commands on your behalf. You need enough experience to catch when they do something wrong, and enough discipline to always review before executing.

---

### Tier 3 -- Full Agentic

**Who:** Advanced users with deep experience in the lab's workflows.

**Allowed uses:**
- Full AI-assisted workflows including SLURM submission
- Multi-file refactoring and pipeline construction
- AI-driven exploration and prototyping

**Requirements:**
- All documentation standards must be enforced (NOTES.md, experiment logs, etc.)
- Project-level `AGENTS.md` files describing AI context for each project
- Must be able to debug AI-generated code without AI assistance
- Must maintain clear provenance of what AI generated vs. what you wrote

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

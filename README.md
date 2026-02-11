# Coding Standards

Basic Raj-Greally lab coding standards/best practices in the context of AI development tools 

- **IF PEOPLE HAVE NO CODING EXPERIENCE, AGENTS ARE OFF LIMITS**

## Startup instructions 

- [ ] Getting started on hpc
- [ ] Getting started LLMs
- [ ] Starter project- 1 week
  - [ ] git
  - [ ] bash commands 
  - [ ] *use hpc basic commands*
  - [ ] *package management*
  - [ ] *run a job*
  - [ ] make a small edit
  - [ ] naming conventions 

## Basic Standards 

- [ ] Starter bashrc
   - basic module load
   - tool paths
   - aliases
 - Bash commands
 - HPC login info stuff
 - SLURM management
 - Start with git
   - .gitignore 

## Algorithmic Development 

- Basic workflows
  - keep seperate contexts for theoretical and technical development
  - Piecemeal buildup with plan and iterative methods
- Unit and smoke tests
- Optimize code based on repo structure
- Use plan mode aggressively
- Package management
  - mamba for creating new environments
  - uv pip for installing specific python packages

## Results/Figure Development

- Marimo

## AI Development

- [ ] Joint Agent/CLAUDE rule set markdown file at the root
  - HPC standardized information
    - HPC sbatch headers
    - Array jobs
  - Reference locations - reference panels, genome etc. 
  - common pipelines (sequencing, global ancestry, local ancestry, ANNOVAR, etc.)
  - Annotations - publicly available databases, instructions on how to call them
  - Common errors: chr1 vs 1
    

- Necessary/recommended MCPs
  - Context7: API calling 
  
- Seperate NOTES/AGENTS.md per project
   - Scripts
   - Paths to inputs
   - Paths to results
   - General debugging tips and information
   - Log of provenance

## Documentation
### Logs
- what was run and what was not
### Notes
- Specific debugging information etc
### Results
- Only experimental details

## Next steps
raj-greally-coding-standards/
├── README.md                          # Overview, philosophy, how to use this repo
├── 00-quickstart/
│   ├── DAY_ONE.md                     # Account setup, SSH, first login, basic navigation
│   ├── STARTER_BASHRC                 # Actual file they can copy
│   ├── SSH_CONFIG_TEMPLATE            # Templatized version of your config
│   └── FIRST_WEEK_PROJECT.md          # The structured 1-week onboarding project
├── 01-hpc-guide/
│   ├── SLURM_BASICS.md               # Partitions, sbatch headers, array jobs, monitoring
│   ├── CONDA_ENVIRONMENTS.md          # Creating, activating, the bashrc gotcha
│   ├── DATA_LOCATIONS.md              # Reference panels, genomes, shared databases
│   └── COMMON_ERRORS.md              # chr1 vs 1, numpy binary compat, etc.
├── 02-coding-standards/
│   ├── PROJECT_STRUCTURE.md           # Directory conventions, naming, what goes where
│   ├── PYTHON_STYLE.md                # Style guide (can be short, defer to ruff/black)
│   ├── GIT_WORKFLOW.md                # What to commit, .gitignore template, branch strategy
│   ├── PACKAGE_MANAGEMENT.md          # mamba vs uv pip, when to make a new env
│   └── TESTING.md                     # Unit tests, smoke tests, validation patterns
├── 03-analysis-standards/
│   ├── DOCUMENTATION.md               # Logs vs Notes vs Results (your three-tier system)
│   ├── REPRODUCIBILITY.md             # Script provenance, parameter logging, figure scripts
│   └── MARIMO_GUIDE.md                # When and how to use marimo notebooks
├── 04-ai-development/
│   ├── AI_POLICY.md                   # Autonomy levels, review requirements, attribution
│   ├── CLAUDE_MD_TEMPLATE.md          # Starter claude.md for new lab members
│   ├── PROJECT_AGENTS_TEMPLATE.md     # Template NOTES.md / AGENTS.md per project
│   └── RECOMMENDED_MCPS.md           # Context7, etc.
├── templates/
│   ├── starter.bashrc
│   ├── ssh_config_template
│   ├── sbatch_template.sh
│   ├── claude_md_template.md
│   ├── project_notes_template.md
│   └── gitignore_template
└── checklists/
    ├── NEW_MEMBER_ONBOARDING.md       # PI/mentor-facing checklist
    └── ROTATION_STUDENT_ONBOARDING.md # Abbreviated version

Originally generated: 2/11/2026

Updated: 2/11/2026

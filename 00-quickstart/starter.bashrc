# =============================================================================
# Einstein HPC Starter .bashrc
# =============================================================================
#
# This file configures your shell environment on the HPC. It runs every time
# you open a new terminal session (SSH login, interactive job, etc.).
#
# HOW TO USE:
#   1. Copy this to ~/.bashrc on the HPC
#   2. Review and fill in any TO_FILL sections
#   3. Run: source ~/.bashrc
#
# Lines marked TO_FILL need to be verified or updated for your specific setup.
# Ask your lab manager or check the HPC documentation for correct values.
#
# SECURITY WARNING:
# Never put tokens, passwords, or API keys in your bashrc.
# Use SSH keys for git authentication. See DAY_ONE.md for SSH key setup.
# =============================================================================


# -----------------------------------------------------------------------------
# Source global definitions
# -----------------------------------------------------------------------------
# The system-wide bashrc sets up default paths and settings for all users.
# Always source this first so you get the standard HPC environment.

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi


# -----------------------------------------------------------------------------
# Module loads
# -----------------------------------------------------------------------------
# Modules are the HPC's way of making software available. Without loading a
# module, the software may not be on your PATH even if it is installed.
#
# TO_FILL: verify these module names match what is available on the cluster.
# Run `module avail` to see all available modules.

module load git        # Version control
module load conda3     # Conda package manager (Python environments)


# -----------------------------------------------------------------------------
# Conda initialization
# -----------------------------------------------------------------------------
# This block sets up conda so you can activate environments with
# `conda activate <env_name>`. Without this, conda commands will not work.
#
# TO_FILL: replace the conda path below with the actual path on the HPC.
# Find it by running: which conda (after module load conda3)
# Common locations: /opt/conda3, /usr/local/conda3, /gs/gsfs0/apps/conda3

# >>> conda initialize >>>
# TO_FILL: The conda init block below needs the correct CONDA_PREFIX path.
# After loading the conda3 module, run `conda init bash` to auto-generate
# this block, or manually set the path below.

__conda_setup="$('/opt/conda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"  # TO_FILL: verify /opt/conda3 path
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/conda3/etc/profile.d/conda.sh" ]; then  # TO_FILL: verify path
        . "/opt/conda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/conda3/bin:$PATH"  # TO_FILL: verify path
    fi
fi
unset __conda_setup

# <<< conda initialize <<<


# -----------------------------------------------------------------------------
# Lab directory aliases
# -----------------------------------------------------------------------------
# These shortcuts let you jump to lab directories quickly.
# Usage: type `raj-lab` or `greally-lab` to cd to the respective directory.

alias raj-lab="cd /gs/gsfs0/users/raj-lab/"
alias greally-lab="cd /gs/gsfs0/users/greally-lab/"


# -----------------------------------------------------------------------------
# Interactive job alias
# -----------------------------------------------------------------------------
# Starts an interactive session on a compute node. This gives you a dedicated
# machine with real resources (CPUs, memory) instead of the shared login node.
#
# Flag breakdown:
#   --partition=normal   Which queue to submit to. "normal" allows up to 3 days.
#   --time=8:00:00       Max wall time: 8 hours. Job is killed after this.
#   --cpus-per-task=8    Request 8 CPU cores for your session.
#   --mem-per-cpu=16G    Request 16 GB of RAM per CPU (8 CPUs x 16G = 128G total).
#   --job-name=bash      Names the job "bash" in the queue (for easy identification).
#   --pty bash           Allocate a pseudo-terminal and start a bash shell.

alias interactive="srun --partition=normal --time=8:00:00 --cpus-per-task=8 --mem-per-cpu=16G --job-name=bash --pty bash"


# -----------------------------------------------------------------------------
# SLURM convenience aliases
# -----------------------------------------------------------------------------
# Quick shortcuts for common SLURM commands.

# Show your currently running and queued jobs
alias run-jobs="squeue -u $USER"

# Show detailed info about recent jobs (last hour)
alias recent-jobs="sacct --format=JobID,JobName,State,Start,Elapsed,ExitCode -u $USER -S now-1hour"


# -----------------------------------------------------------------------------
# Tool paths
# -----------------------------------------------------------------------------
# Genomics tools that may not be on the default PATH.
# TO_FILL: verify these paths. Run `which plink2`, `which qctool`, etc.
# after loading the appropriate modules, or ask your lab manager.

# TO_FILL: uncomment and set correct paths
# export PATH="/gs/gsfs0/apps/plink2:$PATH"      # TO_FILL: verify plink2 path
# export PATH="/gs/gsfs0/apps/qctool:$PATH"       # TO_FILL: verify qctool path
# export PATH="/gs/gsfs0/apps/bgenix:$PATH"        # TO_FILL: verify bgenix path


# -----------------------------------------------------------------------------
# Shell behavior
# -----------------------------------------------------------------------------
# HISTSIZE: number of commands to remember in the current session.
# HISTFILESIZE: number of commands saved to ~/.bash_history on disk.
# Larger values mean you can search further back in your command history
# using the up arrow or Ctrl+R.

export HISTSIZE=10000
export HISTFILESIZE=20000

# Append to history file instead of overwriting (useful with multiple sessions)
shopt -s histappend


# -----------------------------------------------------------------------------
# Useful aliases
# -----------------------------------------------------------------------------
# ll: detailed file listing with human-readable sizes and hidden files
alias ll="ls -lah"

# Show disk usage of current directory, sorted by size
alias duh="du -sh * | sort -h"


# -----------------------------------------------------------------------------
# End of starter .bashrc
# -----------------------------------------------------------------------------
# After filling in the TO_FILL sections, run:
#   source ~/.bashrc
# to apply changes to your current session.

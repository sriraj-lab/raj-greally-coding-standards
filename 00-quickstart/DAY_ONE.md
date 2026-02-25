# Day One: Getting Set Up on the Einstein HPC

Welcome! This guide will walk you through everything you need to connect to the Einstein HPC cluster and run your first command. No prior experience with remote computing is assumed.

**This is still not beginner friendly- most people with no computtational experience have any idea about terminal or things like that. This needs more context**
## Context


- [ ] What is terminal?
  - [ ] move terminal commands here 
- [ ] Why terminal?
  - [ ] basrhc and startup stuff 
- [ ] Why HPC?
  - [ ] Basics of login and compute node 
- [ ] Package management (more context)
- [ ] Change to being more hpc-centric- IDE-based development on the HPC. 

---

## Prerequisites

Before you begin, make sure you have:

1. **An Einstein HPC account** -- your PI or lab manager should have requested this for you. You will need your HPC username (typically your Einstein login, e.g., `jsmith`).
2. **A local terminal** -- on macOS, open the built-in Terminal app (search "Terminal" in Spotlight). On Windows, install [Windows Terminal](https://aka.ms/terminal) with WSL2, or use Git Bash.
3. **An SSH key pair** -- we will generate one in the next section if you do not already have one.
   

---

## Step 1: Generate an SSH Key Pair

An SSH key pair is like a lock and key system. Your computer holds the private key (the "key"), and the HPC stores the public key (the "lock"). This lets you log in without typing a password every time.

Open your terminal and run:

```bash
# Check if you already have a key
ls ~/.ssh/id_rsa.pub
```

If that file exists, you can skip generation. Otherwise, create one:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@einstein.edu"
```

When prompted:
- **File location:** press Enter to accept the default (`~/.ssh/id_rsa`)
- **Passphrase:** enter a strong passphrase (you will type this once per session, not every command)

This creates two files:
- `~/.ssh/id_rsa` -- your private key. **Never share this.**
- `~/.ssh/id_rsa.pub` -- your public key. This goes on the HPC.

---

## Step 2: Copy Your Public Key to the HPC

```bash
ssh-copy-id <YOUR_USERNAME>@hpc.einsteinmed.edu
```

You will be prompted for your HPC password (this is the last time you will need it for login). This command appends your public key to the HPC's `~/.ssh/authorized_keys` file.

If `ssh-copy-id` is not available, you can do it manually:

```bash
cat ~/.ssh/id_rsa.pub | ssh <YOUR_USERNAME>@hpc.einsteinmed.edu "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

---

## Step 3: Set Up Your SSH Config

The SSH config file tells your terminal how to connect to different machines with shortcut names. Instead of typing long hostnames and options every time, you configure them once.

First, create the required directories:

```bash
mkdir -p ~/.ssh/sockets
```

The `sockets` directory is used for **connection multiplexing** -- a feature that lets multiple SSH sessions share a single connection, making subsequent connections instant.

Now copy the SSH config template from this repository:

```bash
cp 00-quickstart/ssh_config_template ~/.ssh/config_template_reference
```

Edit your SSH config (create it if it does not exist):

```bash
# Open your SSH config in a text editor
nano ~/.ssh/config
# Or use: code ~/.ssh/config (if you have VS Code)
```

Paste in the template from `ssh_config_template` in this directory, replacing:
- `<YOUR_USERNAME>` with your HPC username
- `<CURRENT_COMPUTE_NODE>` with any placeholder like `cpu-001` (we will update this later)

Save and set permissions:

```bash
chmod 600 ~/.ssh/config
```

---

## Step 4: Test Your Connection

```bash
ssh hpc-login
```

If everything is configured correctly, you should land on the **login node** with a prompt like:

```
[youruser@login-node ~]$
```

Type `exit` to disconnect for now.

---

## Understanding the Architecture: Login Node vs. Compute Nodes

The HPC cluster has two types of machines:

```
Your Laptop  --->  Login Node (gateway)  --->  Compute Nodes (do the work)
                   hpc-login                   hpc-compute (via ProxyJump)
```

- **Login node (`hpc-login`):** This is the front door. You land here when you SSH in. It is shared by everyone and has limited resources. Use it only for: submitting jobs, checking job status, transferring files.
- **Compute nodes:** These are the powerful machines where you actually run code. You get access to one by starting an **interactive job** (explained below) or by submitting a batch job.

**Important rule:** Never run heavy computation on the login node. It slows things down for everyone.

The `ProxyJump` setting in your SSH config lets you connect directly to a compute node by automatically tunneling through the login node. So `ssh hpc-compute` actually goes: your laptop -> login node -> compute node, but it feels like a direct connection.

---

## Step 5: First Login Checklist

SSH into the login node and complete these setup steps:

```bash
ssh hpc-login
```

### 5a. Copy the Starter Bashrc

Your **bashrc** file (`~/.bashrc`) runs every time you open a new shell session. It sets up your environment: aliases, paths, conda, etc.

From your local machine, copy the starter bashrc to the HPC:

```bash
# Run this locally (not on HPC)
scp 00-quickstart/starter.bashrc <YOUR_USERNAME>@hpc.einsteinmed.edu:~/.bashrc_starter
```

Then on the HPC:

```bash
ssh hpc-login

# Back up your existing bashrc if you have one
cp ~/.bashrc ~/.bashrc.backup 2>/dev/null

# Review the starter before applying
cat ~/.bashrc_starter

# If it looks good, use it (or merge with your existing one)
cp ~/.bashrc_starter ~/.bashrc
source ~/.bashrc
```

### 5b. Verify Conda

Conda is a package manager that creates isolated Python environments so different projects can use different library versions without conflict.

```bash
# Check conda is available
conda --version

# List available environments
conda env list

# Activate the lab's main environment
conda activate local_pca

# Verify Python and key packages
python --version
python -c "import pandas; print('pandas', pandas.__version__)"
python -c "import numpy; print('numpy', numpy.__version__)"
```

### 5c. Verify Tools

```bash
# Check that common genomics tools are accessible
which plink2
which qctool
which bgenix
```

If any of these are missing, check with your lab manager about the correct module loads or paths.

### 5d. Navigate to the Lab Directory

```bash
# Go to the Raj Lab shared space
cd /gs/gsfs0/users/raj-lab/
ls

# Or the Greally Lab shared space
cd /gs/gsfs0/users/greally-lab/
ls
```

---

## Filesystem Orientation

The HPC has several important locations:

| Location | Purpose | Space |
|----------|---------|-------|
| `~/` (home directory) | Config files, small scripts | **Limited quota** -- do not store data here |
| `/gs/gsfs0/users/raj-lab/` | Raj Lab shared data and projects | Large, shared |
| `/gs/gsfs0/users/greally-lab/` | Greally Lab shared data and projects | Large, shared |

**Rule of thumb:** Your home directory is for dotfiles and configs. All data, scripts, and results should live in the shared lab directories.

---

## Step 6: Start an Interactive Job

Remember, the login node is just a gateway. To do real work, you need a compute node. The easiest way to get one is an **interactive job**:

```bash
# On the login node, run:
interactive
```

This command requests a compute node with reasonable defaults (CPUs, memory, time limit). After a moment, your prompt will change to show you are on a compute node:

```
[youruser@cpu-743 ~]$
```

The node name (e.g., `cpu-743`) is your compute node. **Make a note of it** -- you will need it to set up direct SSH access.

### Why Do You Need an Interactive Job?

- The login node is shared and resource-limited. Running code there is slow and inconsiderate.
- An interactive job gives you dedicated resources (CPUs, memory) on a compute node.
- You can run scripts, test code, and explore data freely.

### Update Your Local SSH Config

Back on your local machine (open a new terminal tab), update your SSH config so `hpc-compute` points to your new node:

```bash
# If you added the setnode function to your shell config:
setnode cpu-743  # Replace with your actual node name

# Or manually edit ~/.ssh/config and change the HostName under hpc-compute
```

Now you can connect directly to your compute node:

```bash
ssh hpc-compute
```

---

## Transferring Files

To copy files between your local machine and the HPC, use `scp` (secure copy):

```bash
# Local to HPC (single file)
scp myfile.py hpc-login:/gs/gsfs0/users/raj-lab/yourname/

# HPC to local (single file)
scp hpc-login:/gs/gsfs0/users/raj-lab/yourname/results.csv ./

# Copy a directory (use -r for recursive)
scp -r my_scripts/ hpc-login:/gs/gsfs0/users/raj-lab/yourname/
```

**Note:** `rsync` is not available on this HPC. Always use `scp`.

---

## You Are Ready!

Once you can:

1. SSH into the login node (`ssh hpc-login`)
2. Start an interactive job (`interactive`)
3. Activate conda and verify Python (`conda activate local_pca && python --version`)

...you are ready for the first-week project. See `FIRST_WEEK_PROJECT.md` in this directory.

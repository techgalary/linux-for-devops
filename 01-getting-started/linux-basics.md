# Linux Basics for DevOps Engineers

Welcome to the first lesson in **Linux for DevOps**! This lesson introduces Linux, explains why it matters in DevOps, and walks through essential terminal commands.

> **Goal:** By the end, you should be able to explain what Linux is, open a terminal, run basic commands, and explore your environment safely.

## 1. What is Linux?

Linux is an open-source operating-system kernel. A **Linux distribution** combines the kernel with system tools, libraries, package management, and other software to create a usable operating system.

Common distributions include:

- **Ubuntu** — widely used on developer machines, servers, and in cloud environments.
- **Debian** — known for stability and used as the basis for several other distributions.
- **Red Hat Enterprise Linux (RHEL)** — common in enterprise environments.
- **Rocky Linux / AlmaLinux** — enterprise-oriented distributions compatible with RHEL.
- **Amazon Linux** — designed for use on AWS.
- **Alpine Linux** — a small distribution often used as a container image base.

The commands in this lesson work on most Linux distributions, although some output and optional tools may differ.

## 2. Why DevOps engineers use Linux

Linux is common in DevOps because it is used to run many:

- Cloud virtual machines and application servers
- Docker containers and Kubernetes workloads
- CI/CD runners and build agents
- Web servers, databases, and monitoring tools
- Automation scripts and infrastructure tooling

You do not need to memorise every command. Learn how to inspect a system, find help, understand command output, and troubleshoot methodically.

## 3. Open a Linux terminal

Use one of these options:

- **Linux computer:** Open the Terminal application.
- **Windows:** Use WSL if you have a Linux distribution installed, or use a Linux virtual machine.
- **macOS:** Open Terminal. Many commands are similar, but macOS is not Linux, so some tools and options differ.
- **Cloud lab:** Connect to a Linux virtual machine only if you have permission to access it.

Start by running commands as your normal user. Avoid using `sudo` unless a task specifically requires administrator privileges.

## 4. Understand the command pattern

A common command pattern is:

```bash
command [options] [arguments]
```

For example:

```bash
ls -l /etc
```

- `ls` is the command.
- `-l` is an option that requests a detailed listing.
- `/etc` is the argument specifying which directory to list.

Options and arguments vary by command. Read the command's help before using unfamiliar options.

## 5. Your first commands

Run each command and observe its output.

### Identify your user

```bash
whoami
```

Prints the username of the current account.

### Show the current directory

```bash
pwd
```

`pwd` means **print working directory**. It tells you where you are in the filesystem.

### List files and directories

```bash
ls
ls -l
ls -a
ls -lah
```

- `ls` — list visible entries.
- `ls -l` — show a detailed listing.
- `ls -a` — include hidden entries (names beginning with `.`).
- `ls -lah` — combine detailed output, hidden entries, and human-readable file sizes.

### Display the current date and time

```bash
date
```

The displayed format depends on your system's configuration.

### Show system and kernel information

```bash
uname -a
```

Displays kernel and system information. The exact output varies across systems.

### Clear the terminal display

```bash
clear
```

This clears the visible terminal screen; it does not delete files or command history.

## 6. Get help

You will often encounter commands you have never used. Learn to look up help rather than guessing.

```bash
ls --help
```

Many GNU/Linux commands support `--help`. Not every command does, and options can differ between implementations.

You can also try:

```bash
man ls
```

`man` opens the manual page for `ls`, if the manual is installed. Press `q` to exit the manual viewer.

If a command is missing or its manual is unavailable, search the documentation for your Linux distribution or the tool's official documentation.

## 7. Explore directories safely

Linux uses `/` as the root of the filesystem. Some important directories are:

| Directory | Common purpose |
|---|---|
| `/` | Root of the filesystem |
| `/home` | Home directories for regular users (layout can vary) |
| `/etc` | System and application configuration |
| `/var` | Variable data such as logs, caches, and service data |
| `/tmp` | Temporary files |
| `/usr` | Many user-space programs, libraries, and shared data |
| `/opt` | Optional/add-on application software on many systems |

Explore these directories without changing anything:

```bash
ls /
ls /etc
ls /var
```

Some directories may require elevated permissions to inspect particular files. Do not change system files as part of this introductory lesson.

## 8. Understand paths

A **path** identifies a file or directory.

- **Absolute path:** Starts at `/`, for example `/etc/hosts`.
- **Relative path:** Starts from your current directory, for example `Documents/notes.txt`.
- `.` means the current directory.
- `..` means the parent directory.
- `~` usually represents your home directory in a shell.

Try:

```bash
pwd
cd /
pwd
cd ~
pwd
cd ..
pwd
```

`cd` changes the current directory. After `cd ..`, your location is the parent of the directory you were in.

## 9. Create a safe practice area

Use a directory in your home folder so that the exercises do not affect system files.

```bash
mkdir -p ~/linux-for-devops-practice
cd ~/linux-for-devops-practice
pwd
```

Create a sample directory and empty file:

```bash
mkdir notes
touch notes/lesson-01.txt
ls -lah
ls -lah notes
```

`mkdir -p` creates the directory and any missing parent directories. `touch` creates an empty file if it does not exist; if the file already exists, it updates its timestamps.

Inspect the file without editing it:

```bash
file notes/lesson-01.txt
```

The output describes the file type. Exact wording can vary.

## 10. Command history and terminal shortcuts

Useful commands and shortcuts include:

- `history` — show commands recorded in your shell history.
- **Up / Down arrow** — browse previously entered commands in many shells.
- **Tab** — complete commands and paths in many shells.
- `Ctrl+C` — interrupt a running foreground command in many terminal environments.
- `Ctrl+L` — clear the visible terminal display in many shells.

History behaviour depends on the shell and its configuration. Do not put passwords, tokens, or other secrets directly into commands: they may be exposed in shell history or process information.

## 11. Common beginner mistakes

- **`command: not found`** — check the spelling and whether the tool is installed and available in `PATH`.
- **`No such file or directory`** — check your current directory with `pwd`, then verify the path with `ls`.
- **`Permission denied`** — check the file or directory permissions and whether your account should have access. Do not automatically retry with `sudo`.
- **Unexpected output** — read the command's help or manual and check which distribution or shell you are using.

A good troubleshooting habit is to gather evidence first: inspect the current directory, verify the path, read the error message, and then choose the next step.

## 12. Hands-on exercises

Try these without copying the answers first.

1. Print your username.
2. Display your current directory.
3. List all entries, including hidden ones, in your home directory.
4. Move to `/` and list its contents.
5. Return to your home directory.
6. Create `~/linux-for-devops-practice/day1`.
7. Inside `day1`, create an empty file named `notes.txt`.
8. Display a detailed listing of `day1`.
9. Open the manual for `pwd`, if available, and exit it.
10. Use `history` to inspect some commands you ran.

### Check your work

After exercises 6–8, run:

```bash
ls -lah ~/linux-for-devops-practice/day1
```

You should see `notes.txt`. Its size should be zero bytes if you have not written anything into it.

## 13. Quick knowledge check

1. What is the difference between an absolute path and a relative path?
2. Which command prints your current directory?
3. What does `ls -a` show that a plain `ls` may not?
4. What is the purpose of `/etc`?
5. Why should you avoid using `sudo` for every command?

**Suggested answers**

1. An absolute path starts at `/`; a relative path is interpreted from the current directory.
2. `pwd`.
3. Hidden entries whose names begin with `.`.
4. It stores system and application configuration files.
5. Administrator privileges can make accidental changes more damaging; use them only when needed and authorised.

## What comes next?

In the next lesson, **File and Directory Operations**, you will practise navigating directories and using commands such as `cp`, `mv`, `rm`, `find`, and `cat` safely.

---

**Safety note:** Run practice commands in your own lab or an environment you are authorised to use. Be especially careful with destructive commands such as `rm`, recursive options, and commands run with administrator privileges.

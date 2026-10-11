# 🐧 Linux for DevOps

**Linux fundamentals for DevOps engineers — learn by doing.**

A beginner-friendly, hands-on guide to Linux commands, file permissions, process management, networking, logs, Bash basics, and troubleshooting. This repository is part of the **TechGalary learning series**.

<p align="center">
  <a href="https://github.com/techgalary">
    <img src="https://img.shields.io/badge/TechGalary-Learn%20by%20Building-326CE5?style=for-the-badge" alt="TechGalary">
  </a>
  <img src="https://img.shields.io/badge/Level-Beginner-2EA44F?style=for-the-badge" alt="Beginner level">
  <img src="https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="MIT License">
</p>

---

## 📚 What You'll Learn

- Navigate the Linux filesystem and manage files and directories.
- Understand users, groups, ownership, and permissions.
- Inspect processes, services, memory, CPU, and disk usage.
- Use essential networking and DNS troubleshooting commands.
- Find and inspect logs to investigate common issues.
- Write simple Bash scripts to automate repetitive tasks.
- Apply these skills to practical DevOps troubleshooting scenarios.

## 🗺️ Learning Roadmap

| Module | Topics | Practice |
|---|---|---|
| 01. Getting Started | Terminal, `pwd`, `whoami`, `man`, `history` | Explore your environment |
| 02. Files & Directories | `ls`, `cd`, `mkdir`, `cp`, `mv`, `rm`, `find` | Organize a project directory |
| 03. Reading & Searching | `cat`, `less`, `head`, `tail`, `grep`, `sort`, `wc` | Search an application log |
| 04. Users & Permissions | `whoami`, `id`, `chmod`, `chown`, `sudo` | Inspect and change file permissions |
| 05. Processes & Services | `ps`, `top`, `kill`, `systemctl` | Investigate a running process |
| 06. Disk & Memory | `df`, `du`, `free`, `uptime` | Check system resource usage |
| 07. Networking & DNS | `ip`, `ping`, `curl`, `ss`, `getent`, `dig`* | Troubleshoot connectivity |
| 08. Logs & Troubleshooting | `journalctl`, `dmesg`, `tail -f` | Investigate a simulated incident |
| 09. Bash Basics | Variables, conditions, loops, exit codes | Write a system information script |
| 10. Mini-Project | Combine commands and scripting | Build a basic system health check |

\*Some commands, such as `dig`, may need to be installed separately.

## 🧰 Prerequisites

- A Linux environment, such as Ubuntu, Debian, or a virtual machine.
- Alternatively, use **WSL** on Windows or a Linux container.
- Basic familiarity with a terminal is helpful, but not required.

> **Safety first:** Practice destructive commands only in a test directory or disposable environment. Review commands before running them, and avoid using `sudo` unless you understand why it is needed.

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/techgalary/linux-for-devops.git
cd linux-for-devops
```

Create a safe practice directory:

```bash
mkdir -p ~/linux-for-devops-lab
cd ~/linux-for-devops-lab
```

Try your first commands:

```bash
pwd
whoami
uname -a
ls -la
df -h
free -h
```

Read the manual for any command:

```bash
man ls
```

Press `q` to exit the manual viewer.

## 💻 Essential Command Examples

### 1. Files and directories

```bash
mkdir demo
cd demo
touch app.log
printf "INFO: Application started\nERROR: Connection timed out\n" > app.log
cat app.log
grep "ERROR" app.log
```

### 2. File permissions

```bash
touch deploy.sh
chmod 750 deploy.sh
ls -l deploy.sh
```

`chmod 750` gives the owner read/write/execute permissions, the group read/execute permissions, and others no permissions. Only use permissions appropriate for your environment.

### 3. Processes and resources

```bash
ps aux
uptime
free -h
df -h
du -sh ~/linux-for-devops-lab
```

### 4. Networking

```bash
ip addr
ip route
ping -c 4 1.1.1.1
curl -I https://example.com
ss -tulpn
```

Some commands may require elevated privileges or may be unavailable in restricted containers. A failed `ping` does not always mean a host is unreachable; ICMP traffic may be blocked.

### 5. Inspecting logs

```bash
tail -n 50 app.log
grep -i "error" app.log
tail -f app.log
```

Press `Ctrl+C` to stop following a log.

## 🧪 Hands-On Exercises

Try each task before looking up a solution.

- [ ] Create a directory called `devops-lab` with `scripts`, `logs`, and `backups` subdirectories.
- [ ] Create a sample log file and find every line containing `ERROR`.
- [ ] Create a script file and set its permissions to `750`.
- [ ] Find the five largest entries in a practice directory.
- [ ] Display the current date, logged-in user, uptime, and available disk space.
- [ ] Use `curl` to inspect the HTTP response headers from a public website.
- [ ] Find a service's status on a Linux system that uses `systemd`.

**Tip:** Commands and options can differ between Linux distributions. Check `man <command>` or `<command> --help` when in doubt.

## 🛠️ Mini-Project: Basic System Health Check

Create a file named `system-health.sh`:

```bash
#!/usr/bin/env bash
set -u

echo "===== System Health Check ====="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo
echo "----- Uptime -----"
uptime
echo
echo "----- Memory -----"
free -h
echo
echo "----- Disk Usage -----"
df -h
```

Run it:

```bash
chmod +x system-health.sh
./system-health.sh
```

This is a learning example, not a production monitoring agent. Extend it to check a specific filesystem threshold, report failed checks, and return a meaningful exit code.

## 📂 Repository Structure

```text
linux-for-devops/
├── README.md
├── 01-getting-started/
├── 02-files-and-directories/
├── 03-reading-and-searching/
├── 04-users-and-permissions/
├── 05-processes-and-services/
├── 06-disk-and-memory/
├── 07-networking-and-dns/
├── 08-logs-and-troubleshooting/
├── 09-bash-basics/
├── exercises/
└── mini-projects/
```

The folders can be added progressively as each module is developed.

## 🤝 Contributing

Found an error or want to add an example? Contributions are welcome.

1. Fork this repository.
2. Create a branch for your change.
3. Add or improve an example, exercise, or explanation.
4. Open a pull request describing the change.

Please keep examples beginner-friendly, safe to run, and clear about any required privileges.

## 🌐 Explore TechGalary

- **Website:** https://sowmyanarayan.com
- **YouTube:** https://www.youtube.com/@techgalary/
- **GitHub:** https://github.com/techgalary

---

<p align="center">
  <i>Learn by building. Share what you learn. Grow together.</i>
</p>

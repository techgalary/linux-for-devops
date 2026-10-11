# Linux for DevOps — Practice Exercises

Use these exercises to reinforce the lessons in this repository. Start in a practice directory, use sample files, and avoid running destructive commands on system or production data.

## How to use this workbook

- Try each task before looking at the hints.
- Run commands in your own Linux lab or an environment you are authorised to use.
- Check the output and explain what it means; don't just copy commands.
- Keep notes about unexpected results and how you investigated them.

Create a workspace:

```bash
mkdir -p ~/linux-for-devops-practice/exercises
cd ~/linux-for-devops-practice/exercises
```

---

## Exercise 1: Getting started

**Tasks**

1. Print the current username.
2. Display the current directory.
3. Show hidden entries in your home directory.
4. Display kernel information.
5. Find the manual page for `pwd`, if available.

**Hints**

Commands to explore: `whoami`, `pwd`, `ls -a`, `uname -a`, `man`.

**Self-check**

- Can you explain the difference between your username and your current directory?
- Can you describe what `uname -a` tells you?

## Exercise 2: Files and directories

**Tasks**

1. Create a directory named `day1`.
2. Inside it, create `notes.txt`.
3. Add two lines to the file.
4. Copy it to `notes-backup.txt`.
5. Rename the backup to `notes-archive.txt`.
6. Display the contents of both files.
7. Find all `.txt` files beneath the exercise workspace.

**Hints**

Explore `mkdir`, `printf`, `cat`, `cp`, `mv`, and `find`.

**Safety reminder:** `>` overwrites a file; `>>` appends. Verify your current directory before deleting anything.

## Exercise 3: Reading and searching text

Create a sample log:

```bash
cat > app.log <<'EOF'
INFO application started
WARN request retry scheduled
ERROR database unavailable
INFO retrying connection
ERROR database unavailable
INFO health check passed
EOF
```

**Tasks**

1. Display the first three and last three lines.
2. Find lines containing `ERROR`.
3. Show line numbers for errors.
4. Count the matching error lines.
5. Save error lines to `errors-only.log`.
6. Count entries by severity.

**Hints**

Explore `head`, `tail`, `grep`, `wc`, and `awk`.

**Self-check**

How many error lines should the sample contain? Why does `grep -c 'ERROR' app.log` count matching lines rather than every word occurrence?

## Exercise 4: Permissions

**Tasks**

1. Create `private.txt`.
2. Set its mode to `600`.
3. Create `team.txt` and set its mode to `640`.
4. Create a directory called `private-data` and set its mode to `700`.
5. Verify all modes.
6. Explain the difference between file execute permission and directory execute permission.

**Hints**

Explore `chmod`, `ls -l`, and `ls -ld`.

**Safety reminder:** Practise only in your own workspace. Don't use `chmod 777` as a general fix.

## Exercise 5: Processes

**Tasks**

1. List processes.
2. Inspect resource usage interactively and exit cleanly.
3. Check memory usage and uptime.
4. Start a harmless background test process with `sleep 300 &`.
5. Identify the PID of that test process.
6. Stop only the process you started and verify it has ended.

**Hints**

Explore `ps`, `top`, `free -h`, `uptime`, `jobs`, and `kill`.

**Safety reminder:** Never stop unfamiliar or production processes as practice. Record the test PID and make sure you target only your own `sleep` process.

## Exercise 6: Disk and memory

**Tasks**

1. Display filesystem capacity.
2. Check the filesystem containing your home directory.
3. Estimate the size of the exercise workspace.
4. Inspect inode usage.
5. Identify available memory.
6. Explain why high memory usage does not automatically indicate a problem on Linux.

**Hints**

Explore `df -h`, `df -i`, `du -sh`, and `free -h`.

## Exercise 7: Networking and DNS

**Tasks**

1. Display network interfaces and addresses.
2. Display the routing table.
3. Resolve `localhost`.
4. If available, query `example.com` with `dig` or `nslookup`.
5. Inspect listening TCP sockets.
6. Explain why a failed `ping` does not always mean a web service is down.

**Hints**

Explore `ip`, `getent`, `ss`, `ping`, and `curl`.

**Safety reminder:** Only test destinations you are authorised to test. Network policy may block some diagnostics.

## Exercise 8: Logs and troubleshooting

Use the sample `app.log` from Exercise 3.

**Tasks**

1. Show the most recent entries.
2. Find warnings and errors.
3. Display context around each error.
4. Create a short timeline of the sample events.
5. Write three investigation steps you would take if an application started failing after a deployment.

**Hints**

Explore `tail`, `grep -E`, `grep -C`, and `journalctl` where systemd is available.

**Self-check**

Why is it useful to inspect the lines before and after an error?

## Exercise 9: Bash scripting

Create `hello.sh`:

```bash
cat > hello.sh <<'EOF'
#!/usr/bin/env bash
set -u

NAME="${1:-friend}"
printf 'Hello, %s!\n' "$NAME"
printf 'Host: %s\n' "$(hostname)"
EOF
```

**Tasks**

1. Run the script through Bash.
2. Run it with your own name as an argument.
3. Make it executable and run it directly.
4. Check syntax with `bash -n`.
5. Trace execution with `bash -x`.
6. Explain why quoting `"$NAME"` is useful.

**Safety reminder:** Trace output can expose sensitive values. This example uses non-sensitive data only.

---

## Capstone challenge: Build a system health snapshot

**Goal:** Create a script called `system-health.sh` that reports:

- Timestamp and hostname
- Current user
- Uptime and load averages
- Memory usage
- Filesystem capacity

**Requirements**

1. Use a Bash shebang.
2. Print clear section headings.
3. Quote variable expansions where appropriate.
4. Check whether optional commands are available before calling them.
5. Keep the script read-only: it must not modify system settings or delete files.
6. Run it and review the output.
7. Add a short section to your repository README describing what the script checks and how to run it.

**Stretch goals**

- Accept a mount point as an argument and show capacity for that path.
- Return a non-zero exit code if a required command is missing.
- Add a warning when a filesystem exceeds a configurable usage threshold, while making the threshold and its limitations clear.
- Add example output to the project documentation with any sensitive machine details removed.

## Suggested completion checklist

- [ ] I ran the commands rather than only reading them.
- [ ] I understand what each command is checking.
- [ ] I verified file paths before changing or removing files.
- [ ] I can explain the result in my own words.
- [ ] I completed the capstone script.
- [ ] I documented how to reproduce the project.

## Reflection

Write a few sentences answering:

1. Which command did you find most useful?
2. Which error did you encounter, and how did you diagnose it?
3. What would you check first if a Linux server had a full disk?
4. What would you check first if an application could not resolve a hostname?
5. Which topic do you want to practise further?

---

**Safety note:** All exercises are intended for a local lab or an environment you are authorised to use. Never run unfamiliar commands with administrator privileges, and do not expose credentials, tokens, or unredacted production logs.

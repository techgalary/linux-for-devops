# File and Directory Operations

In this lesson, you will learn how to create, inspect, copy, move, rename, search for, and remove files and directories in Linux.

> **Goal:** Practise common filesystem operations in a dedicated lab directory before using them on real systems.

## 1. Start in your practice directory

Use the practice area created in Lesson 1:

```bash
mkdir -p ~/linux-for-devops-practice/day2
cd ~/linux-for-devops-practice/day2
pwd
```

Keep the examples in this lesson inside this directory. Avoid practising destructive commands in system directories or on files you need.

## 2. Create files and directories

### Create a directory

```bash
mkdir reports
```

Create nested directories:

```bash
mkdir -p app/config
```

The `-p` option creates missing parent directories and does not complain if the target directory already exists.

### Create an empty file

```bash
touch notes.txt
```

Create a few sample files:

```bash
touch app.log error.log access.log
```

**Important:** `touch` creates a file if it does not exist. If it already exists, it updates its timestamps; it does not erase the file's contents.

## 3. Read and inspect files

Create a small sample file:

```bash
printf 'Application started\nINFO: Health check passed\nERROR: Example failure\n' > app.log
```

The `>` operator redirects output into a file and **overwrites** the file if it already exists. Use it only when that is intended.

Display the complete file:

```bash
cat app.log
```

Display the first lines:

```bash
head app.log
head -n 2 app.log
```

Display the last lines:

```bash
tail app.log
tail -n 2 app.log
```

Follow new lines added to a log:

```bash
tail -f app.log
```

Press `Ctrl+C` to stop following the file. `tail -f` is useful when troubleshooting a service that writes logs to a file.

Count lines, words, and bytes:

```bash
wc app.log
wc -l app.log
```

## 4. Copy files and directories

Copy a file:

```bash
cp app.log app-backup.log
```

Copy a file into a directory:

```bash
mkdir backups
cp app.log backups/
```

Copy a directory and its contents:

```bash
cp -r reports reports-backup
```

The `-r` option copies directories recursively. Check the destination before copying, especially if files with the same names already exist.

Verify the results:

```bash
ls -lah
ls -lah backups
```

## 5. Move and rename files

`mv` can move a file to another directory or rename it.

Rename a file:

```bash
mv notes.txt notes-old.txt
```

Move a file into a directory:

```bash
mv notes-old.txt reports/
```

Check where it went:

```bash
ls -lah reports
```

Be careful: moving a file onto an existing destination can replace that destination in some circumstances. Inspect the destination first and use interactive options such as `mv -i` when appropriate.

## 6. Remove files and directories

Remove one file:

```bash
rm error.log
```

Remove an empty directory:

```bash
rmdir reports-backup
```

`rmdir` only removes empty directories. If the directory contains files, it fails rather than deleting them.

### A safety habit for deletion

Before removing anything, inspect the target:

```bash
pwd
ls -lah
```

For an interactive confirmation before removing a file:

```bash
rm -i app-backup.log
```

Read the prompt carefully before confirming.

**Avoid running `rm -rf` casually.** It can recursively delete directories and their contents without prompting. Never experiment with destructive commands on a production machine or on paths you have not verified.

## 7. Search for files and directories

Find files by name inside the current directory tree:

```bash
find . -name '*.log'
```

The quotes protect the wildcard so `find` can interpret it.

Find directories named `backups`:

```bash
find . -type d -name backups
```

Find regular files:

```bash
find . -type f
```

Find files modified within the last day:

```bash
find . -type f -mtime -1
```

The meaning of time-based filters can be less intuitive than expected; consult `man find` when building a real operational command.

## 8. Search inside files with `grep`

Search for a word or pattern in a file:

```bash
grep 'ERROR' app.log
```

Ignore letter case:

```bash
grep -i 'error' app.log
```

Show line numbers:

```bash
grep -n 'ERROR' app.log
```

Search all `.log` files in the current directory:

```bash
grep -n 'ERROR' ./*.log
```

Search recursively through files below the current directory:

```bash
grep -Rni 'ERROR' .
```

Recursive searches can include many files. Start in a specific directory when possible, and avoid searching locations that may contain secrets or sensitive data.

## 9. Understand redirection and appending

Overwrite a file with command output:

```bash
printf 'First line\n' > sample.txt
```

Append another line:

```bash
printf 'Second line\n' >> sample.txt
```

Read the result:

```bash
cat sample.txt
```

- `>` writes output to a file, replacing its previous contents.
- `>>` appends output to the end of a file.

This distinction matters when collecting command output or writing logs.

## 10. Useful file metadata

List details, including permissions, owner, size, and modification time:

```bash
ls -l app.log
```

Show the file type:

```bash
file app.log
```

Show disk usage for a file:

```bash
du -h app.log
```

Show the size of a directory and its contents:

```bash
du -sh .
```

`du` reports disk usage, which may differ from a file's apparent size.

## 11. DevOps practice: inspect a sample log

Create a log file:

```bash
cat > service.log <<'EOF'
INFO service started
INFO configuration loaded
WARN retrying request
ERROR database connection failed
INFO retry scheduled
EOF
```

Now answer these questions with commands:

1. Display the log.
2. Show only lines containing `ERROR`.
3. Show line numbers for warnings and errors.
4. Count the number of lines.
5. Copy the log to `service-backup.log`.
6. Find all `.log` files under the current directory.
7. Confirm that both the original and backup exist.

Useful commands:

```bash
cat service.log
grep 'ERROR' service.log
grep -n -E 'WARN|ERROR' service.log
wc -l service.log
cp service.log service-backup.log
find . -type f -name '*.log'
ls -l service.log service-backup.log
```

The `-E` option enables extended regular expressions, allowing `WARN|ERROR` to match either pattern.

## 12. Exercises

Try these independently in `~/linux-for-devops-practice/day2`.

1. Create a directory called `webapp`.
2. Inside it, create `logs`, `config`, and `backups` directories.
3. Create `logs/webapp.log` with at least three lines of sample log output.
4. Display the first two lines and last two lines of the log.
5. Copy the log into `backups/`.
6. Rename the backup to `webapp-2026-10-11.log`.
7. Search for `ERROR` in the original log.
8. Find every `.log` file under `webapp`.
9. List the files with their sizes and modification times.
10. Remove a test file you created, after verifying its path.

## 13. Knowledge check

1. What is the difference between `cp` and `mv`?
2. What does `rm -i` do?
3. How does `>` differ from `>>`?
4. What is the difference between `find` and `grep`?
5. Why should you verify a path before running a deletion command?

**Suggested answers**

1. `cp` copies; `mv` moves or renames.
2. It asks for confirmation before removing a file.
3. `>` overwrites the destination file; `>>` appends to it.
4. `find` locates filesystem entries; `grep` searches text for matching patterns.
5. A wrong path can delete the wrong files, potentially causing data loss or an outage.

## What comes next?

The next lesson covers **Linux Permissions and Ownership**: reading permission bits, using `chmod`, understanding `chown`, and diagnosing `Permission denied` errors.

---

**Safety note:** Practise only in environments you own or are authorised to use. Be cautious with overwriting redirection, recursive operations, and deletion commands.

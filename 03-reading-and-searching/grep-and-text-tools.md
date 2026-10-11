# Linux Permissions and Ownership

Linux permissions control who can read, modify, or execute files and who can access directories. Understanding them helps DevOps engineers troubleshoot deployment failures, service errors, scripts that will not run, and access problems.

> **Goal:** Read permission bits, understand user/group/other access, use `chmod` in a practice directory, and diagnose common `Permission denied` errors.

## 1. Start in a safe practice directory

```bash
mkdir -p ~/linux-for-devops-practice/day3
cd ~/linux-for-devops-practice/day3
pwd
```

Keep this lesson's experiments here. Do not change permissions on system files or production resources as practice.

Create a sample file and directory:

```bash
printf 'Hello from Linux permissions practice\n' > hello.txt
mkdir reports
```

## 2. Read the output of `ls -l`

Run:

```bash
ls -l hello.txt
ls -ld reports
```

A file listing might look like this:

```text
-rw-r--r-- 1 alex developers 36 Oct 11 12:00 hello.txt
```

The exact owner, group, size, and date will vary. The first field contains the file type and permission bits.

| Part | Meaning |
|---|---|
| `-` | A regular file (`d` indicates a directory; other types have other symbols) |
| `rw-` | Owner can read and write, but not execute |
| `r--` | Group can read |
| `r--` | Other users can read |
| `alex` | Example owner |
| `developers` | Example group |

The permission bits are grouped into **owner**, **group**, and **others**. “Others” means users who are neither the file owner nor members of the file's group for this permission check.

## 3. What do read, write, and execute mean?

### For a regular file

- **Read (`r`)** — read the file's contents.
- **Write (`w`)** — modify the file's contents.
- **Execute (`x`)** — run the file as a program or script, subject to other requirements.

### For a directory

- **Read (`r`)** — list directory entries.
- **Write (`w`)** — create, remove, or rename entries inside the directory, subject to other requirements.
- **Execute (`x`)** — traverse/search the directory; this is usually needed to access items inside it by name.

Directory permissions can be unintuitive. For example, reading a file may require execute permission on every directory in its path, not just read permission on the file itself.

## 4. Change permissions with symbolic notation

Use `chmod` to change mode bits.

```bash
chmod u+x hello.txt
```

This adds execute permission for the owner (`u`).

Other symbolic examples:

```bash
chmod g+r hello.txt
chmod o-r hello.txt
chmod a+r hello.txt
```

- `u` — owner/user
- `g` — group
- `o` — others
- `a` — all three categories
- `+` — add permission
- `-` — remove permission
- `=` — set the specified permissions exactly for the selected category

For example, to remove execute permission from everyone:

```bash
chmod a-x hello.txt
```

Inspect each change:

```bash
ls -l hello.txt
```

## 5. Understand numeric permissions

Permissions can also be expressed with numbers:

| Permission | Value |
|---|---:|
| Read (`r`) | 4 |
| Write (`w`) | 2 |
| Execute (`x`) | 1 |

Add the values for each category. For example, `7 = 4 + 2 + 1`, which means read, write, and execute.

| Mode | Owner | Group | Others | Common interpretation |
|---|---|---|---|---|
| `644` | `rw-` | `r--` | `r--` | Owner writes; everyone can read |
| `640` | `rw-` | `r--` | `---` | Owner writes; group reads; others have no access |
| `600` | `rw-` | `---` | `---` | Only owner has read/write bits |
| `755` | `rwx` | `r-x` | `r-x` | Owner writes; group and others read/traverse/execute |
| `700` | `rwx` | `---` | `---` | Only owner has access bits |

Try:

```bash
chmod 640 hello.txt
ls -l hello.txt
chmod 644 hello.txt
ls -l hello.txt
```

The `chmod 644` example is common for non-secret, readable files. Do not apply it blindly to private keys, secrets, or files that need restricted access.

## 6. Set permissions on directories

Create a private directory for practice:

```bash
mkdir private
chmod 700 private
ls -ld private
```

Mode `700` gives the owner read, write, and execute permissions and gives group and others no permission bits.

For a directory, execute permission allows traversal. Removing it can prevent users from accessing items inside even if those items themselves are readable.

Avoid recursively changing permissions on broad paths. Commands such as `chmod -R` can cause widespread access problems when used on the wrong directory.

## 7. Understand ownership and groups

Each file has an owner and a group. Inspect them with:

```bash
ls -l hello.txt
id
```

`id` shows your user and group IDs. The names shown by `ls -l` are examples; your account will likely be different.

### Change ownership with `chown`

Changing ownership normally requires administrator privileges or other specific permissions. The following is an **example only**; do not run it unless you own or administer the system and have a clear reason:

```bash
sudo chown user:group hello.txt
```

Replace `user` and `group` with valid account and group names. On a personal practice machine, you generally do not need `chown` for this lesson.

### Change group with `chgrp`

Changing a file's group may require suitable privileges or membership in the target group:

```bash
chgrp groupname hello.txt
```

Treat `groupname` as a placeholder, not a literal group to copy. You can learn how this works without changing ownership on a shared or production system.

## 8. Diagnose `Permission denied`

If an operation fails, investigate before changing permissions.

```bash
whoami
id
pwd
ls -l hello.txt
ls -ld .
```

Check:

1. Are you the expected user?
2. Does the file or directory have the required permissions?
3. Do you have execute/traverse permission on parent directories?
4. Is the filesystem mounted read-only?
5. Could additional controls such as ACLs, SELinux, or another security policy apply?

Do not assume that adding `777` or running everything with `sudo` is the right fix. Those actions can create security risks and hide the actual cause.

## 9. Executable scripts

Create a tiny shell script:

```bash
printf '#!/bin/sh\necho "Hello from a script"\n' > hello.sh
```

Inspect its permissions:

```bash
ls -l hello.sh
```

Add execute permission for the owner:

```bash
chmod u+x hello.sh
```

Run it:

```bash
./hello.sh
```

The `./` means “run the file from the current directory.” A script also needs a valid interpreter and suitable contents to run successfully.

You can run the script through the shell without setting its executable bit:

```bash
sh hello.sh
```

This is useful for understanding the difference between running a script through an interpreter and executing it directly.

## 10. A note about `umask`

`umask` influences the default permission bits removed when new files and directories are created. It is not a permission mode that you simply apply to an existing file.

Inspect your current setting:

```bash
umask
```

The value and resulting defaults depend on the environment and application. For this lesson, inspect it but do not change your login or system configuration.

## 11. Hands-on exercises

Use only `~/linux-for-devops-practice/day3`.

1. Create a file called `public.txt`.
2. Set its mode to `644` and verify with `ls -l`.
3. Change it to `600` and verify again.
4. Create a directory called `private-data` and set its mode to `700`.
5. Create `run-me.sh` with a simple `echo` command.
6. Add execute permission for the owner and run it with `./run-me.sh`.
7. Remove the execute bit and run it with `sh run-me.sh`.
8. Use `id` to inspect your user and groups.
9. Use `umask` to inspect your current setting.

### Check your work

```bash
ls -l public.txt run-me.sh
ls -ld private-data
```

Your final modes should reflect the changes you made. File owners, groups, and timestamps will vary.

## 12. Knowledge check

1. What are the three permission categories?
2. What does `rwxr-x---` mean?
3. What is the numeric value of `rw-`?
4. Why does a directory often need execute permission?
5. Why is `chmod 777` usually a poor default troubleshooting fix?
6. What does `umask` influence?

**Suggested answers**

1. Owner, group, and others.
2. Owner has read/write/execute; group has read/execute; others have no permission bits.
3. `6` (`4 + 2`).
4. Execute permission allows traversal/search through the directory.
5. It grants broad access and can expose or allow modification of files unnecessarily.
6. It influences which permission bits are removed from default permissions when new files and directories are created.

## What comes next?

The next lesson covers **Processes and Services**: inspecting running processes, checking resource usage, stopping processes carefully, and understanding how services are managed on many Linux systems.

---

**Safety note:** Use permission and ownership commands only on files and systems you are authorised to administer. Avoid broad recursive changes and never loosen permissions on secrets just to make an error disappear.

# Linux Users and Permissions

Linux is a multi-user operating system. Users and groups help control who can access files, run commands, and manage services. This lesson explains the basics and shows how to investigate access problems safely.

> **Goal:** Understand user and group identity, read permission bits, use `chmod` in a practice directory, and diagnose common `Permission denied` errors.

## 1. Start in a safe practice directory

```bash
mkdir -p ~/linux-for-devops-practice/day5
cd ~/linux-for-devops-practice/day5
pwd
```

Run the exercises here rather than changing system files or production resources.

## 2. Identify your user and groups

Show the current username:

```bash
whoami
```

Show your user ID and group memberships:

```bash
id
```

Show account details from the system's user database:

```bash
getent passwd "$(whoami)"
```

The output format for `getent passwd` includes fields such as username, user ID (UID), primary group ID (GID), home directory, and login shell. Some systems may not have `getent` available.

List group information for your current user:

```bash
groups
```

A Linux system can have many users, including service accounts used to run applications. Do not assume a service account should be used for an interactive login.

## 3. Users, groups, and ownership

Each filesystem object has an owner and an associated group. Inspect a file:

```bash
printf 'Sample configuration\n' > app.conf
ls -l app.conf
```

The listing shows permission bits, link count, owner, group, size, modification time, and name. Exact values depend on your system.

- **Owner:** The user associated with the file.
- **Group:** The group associated with the file.
- **Others:** Users who are neither the owner nor members of the file's group for that access check.

Groups make it easier to grant shared access to a team without giving every user administrator privileges.

## 4. Read file permission bits

Example output:

```text
-rw-r----- 1 alex developers 20 Oct 11 12:00 app.conf
```

The first character identifies the file type (`-` for a regular file and `d` for a directory). The next nine characters represent permissions for owner, group, and others:

- `r` — read
- `w` — write
- `x` — execute
- `-` — permission not granted in that position

In this example, the owner can read and write, the group can read, and others have no permission bits.

Inspect your own file:

```bash
ls -l app.conf
```

## 5. Change permissions with `chmod`

Use symbolic permissions:

```bash
chmod u+rw app.conf
chmod g+r app.conf
chmod o-rwx app.conf
ls -l app.conf
```

Symbols:

- `u` — owner/user
- `g` — group
- `o` — others
- `a` — all categories
- `+` — add permission
- `-` — remove permission
- `=` — set permissions for the selected category

Use numeric permissions:

| Mode | Owner | Group | Others | Typical use |
|---|---|---|---|---|
| `600` | Read/write | None | None | Private file owned by you |
| `640` | Read/write | Read | None | File shared read-only with its group |
| `644` | Read/write | Read | Read | Non-secret readable file |
| `700` | Read/write/execute | None | None | Private directory or executable file |
| `755` | Read/write/execute | Read/execute | Read/execute | Publicly traversable directory or executable |

Try:

```bash
chmod 600 app.conf
ls -l app.conf
chmod 640 app.conf
ls -l app.conf
```

Choose modes based on the actual access needed. Do not apply `644` or `755` indiscriminately to secrets, private keys, or sensitive configuration.

## 6. File permissions versus directory permissions

For a regular file:
- `r` allows reading its contents.
- `w` allows modifying its contents.
- `x` allows executing it as a program, subject to other requirements.

For a directory:
- `r` allows listing entries.
- `w` allows creating, removing, or renaming entries, subject to other requirements.
- `x` allows traversal/search through the directory.

Try:

```bash
mkdir private
chmod 700 private
ls -ld private
```

A user often needs execute permission on each parent directory in a path to access a file inside it. This is one reason a file that appears readable may still be inaccessible.

## 7. Understand ownership commands

Inspect the current owner and group:

```bash
ls -l app.conf
```

`chown` changes ownership and usually requires administrator privileges or other specific permissions. The following is an example only; do not run it unless you administer the system and know the intended owner:

```bash
sudo chown username:groupname app.conf
```

Replace the placeholders with real, appropriate account and group names. You do not need to change ownership to complete this lesson.

`chgrp` changes a file's group when the caller has the required permission:

```bash
chgrp groupname app.conf
```

Again, `groupname` is a placeholder. Avoid experimenting with ownership changes on shared or production systems.

## 8. Understand `sudo`

`sudo` runs a command with elevated privileges when the current account is authorised to do so. It is useful for legitimate administrative tasks, but it is not a universal fix for errors.

Before using it, ask:
1. Does this task genuinely require administrator privileges?
2. Do I understand what the command will change?
3. Have I verified the target path and arguments?
4. Am I authorised to make this change?

Prefer inspecting the problem first rather than retrying every failed command with `sudo`.

## 9. Diagnose `Permission denied`

When a command fails, gather evidence:

```bash
whoami
id
pwd
ls -l app.conf
ls -ld .
```

Check:
- Whether you are using the expected account.
- Whether the file permissions allow the required operation.
- Whether parent directories allow traversal.
- Whether the filesystem is mounted read-only.
- Whether additional access controls, such as ACLs or SELinux, apply.

Do not automatically use `chmod 777`. That grants broad access and may expose data or allow unwanted changes.

## 10. Optional: inspect access control lists

Some systems support Access Control Lists (ACLs), which can grant permissions to specific users or groups beyond the basic owner/group/other bits.

If the `getfacl` tool is installed, inspect a file with:

```bash
getfacl app.conf
```

Do not change ACLs on shared systems unless you understand the policy and have permission to administer them. ACL support and available tools vary by distribution and filesystem.

## 11. Hands-on exercises

Complete these in `~/linux-for-devops-practice/day5`.

1. Print your username and group memberships.
2. Create `private.txt` and set its permissions to `600`.
3. Create `team.txt` and set its permissions to `640`.
4. Create a directory named `private-data` and set its permissions to `700`.
5. Use `ls -l` and `ls -ld` to verify the permissions.
6. Explain why execute permission on a directory is different from execute permission on a script.
7. Find the owner and group of each file you created.
8. Inspect `umask` to see which permission bits are normally removed from defaults.

Commands to verify your work:

```bash
ls -l private.txt team.txt
ls -ld private-data
id
umask
```

## 12. Knowledge check

1. What information does `id` display?
2. What do the three permission categories mean?
3. What does mode `640` allow?
4. Why does a directory usually need execute permission for traversal?
5. Why is `sudo` not the first response to every access error?
6. What is an ACL?

**Suggested answers**

1. The current user's UID, primary GID, and group memberships.
2. Owner, group, and others.
3. Owner can read/write, group can read, and others have no permission bits.
4. Execute permission allows the user to traverse/search the directory.
5. It can make unintended system-wide changes and does not explain the underlying cause.
6. An Access Control List can provide more specific access rules for users or groups.

## What comes next?

Continue to `05-processes-and-services/process-management.md` to learn how to inspect processes, understand resource usage, and manage services safely.

---

**Safety note:** Practise only in an environment you own or are authorised to administer. Avoid broad recursive permission changes and never loosen access to sensitive files just to bypass an error.

# Linux Disk and Memory Resources

DevOps engineers need to know whether a system is running out of disk space, using too much memory, or experiencing resource pressure. This lesson covers basic inspection commands and a safe troubleshooting workflow.

> **Goal:** Inspect filesystem capacity, directory usage, memory, swap, and resource-related information without making destructive changes.

## 1. Start with basic system checks

```bash
date
uptime
hostname
```

These commands show the current date/time, system uptime and load averages, and the system's hostname.

Load average is not a CPU percentage. Interpret it alongside CPU count, workload, I/O activity, and other metrics.

## 2. Check filesystem capacity with `df`

Run:

```bash
df -h
```

`df` reports filesystem space. The `-h` option uses human-readable units.

Important columns commonly include:
- **Filesystem** — the filesystem or storage source.
- **Size** — total reported capacity.
- **Used** — space in use.
- **Avail** — space available to non-privileged users, depending on filesystem rules.
- **Use%** — percentage used.
- **Mounted on** — mount point.

To check the filesystem containing your home directory:

```bash
df -h "$HOME"
```

To show filesystem types as well:

```bash
df -hT
```

Filesystem types and output vary by operating system and environment. Containerized systems may display overlay filesystems or storage limits that differ from the underlying host.

## 3. Check directory and file usage with `du`

`df` shows filesystem capacity; `du` estimates space used by files and directories.

Check the size of the current directory:

```bash
du -sh .
```

Check individual entries:

```bash
du -sh ./*
```

The wildcard may not include hidden entries. Shell behaviour and permissions can affect results.

Check the size of a specific directory:

```bash
du -sh "$HOME"
```

This can take time for directories with many files. Avoid scanning large shared or production paths without authorisation.

### Find large directories

For a quick view of the largest entries one level below the current directory:

```bash
du -h --max-depth=1 . 2>/dev/null | sort -h
```

`--max-depth` is supported by GNU `du`; other implementations may use different options. `2>/dev/null` hides error messages, which is convenient for a summary but can conceal permission issues. When troubleshooting, consider running without it so you can see errors.

## 4. Understand disk space versus inodes

A filesystem can have free space in bytes but run out of inodes, which track filesystem objects such as files and directories.

Inspect inode usage:

```bash
df -i
```

If inode usage is at 100%, creating new files may fail even when `df -h` shows free capacity.

Do not delete files blindly to resolve either disk or inode pressure. First identify the affected filesystem and what is consuming the resources.

## 5. Check memory with `free`

Run:

```bash
free -h
```

On Linux, useful columns include total, used, free, shared, buff/cache, and available memory. The **available** value is often more informative than the `free` value alone because Linux uses some memory for caches that can be reclaimed.

Inspect detailed memory information:

```bash
cat /proc/meminfo
```

`/proc` is a virtual filesystem exposing kernel and process information; it is not ordinary data stored on disk.

## 6. Check swap

Swap is storage that the operating system can use to back some memory pages when needed. It is not a substitute for sufficient RAM, and heavy swap activity may affect performance.

Check swap summary:

```bash
swapon --show
```

You can also inspect swap totals in:

```bash
free -h
```

The `swapon` command may not be available in every environment or may require permissions for some operations. The command above only displays configuration; do not enable or disable swap as part of this lesson.

## 7. Observe resource usage

Use:

```bash
top
```

Press `q` to quit.

Look for:
- Processes using unusually high CPU.
- Processes using significant memory.
- Load averages that remain elevated.
- Symptoms reported by users or applications at the same time.

High memory usage is not automatically a problem. Linux caches data in memory, and the kernel can often reclaim some of it when applications need memory. Correlate metrics with application behaviour and system logs.

## 8. Check disk and memory information for a specific process

First, identify the process and its PID:

```bash
ps aux
```

Replace `1234` with a real PID from your own system:

```bash
ps -p 1234 -o pid,user,%cpu,%mem,rss,vsz,etime,cmd
```

`RSS` is resident memory currently in RAM; `VSZ` is virtual memory size. Neither number alone tells the full story about an application's memory health.

For a process's open file descriptors, if permitted:

```bash
ls -l /proc/1234/fd
```

Replace `1234` with the PID you are investigating. Access may be restricted. Do not inspect other users' processes unless you are authorised.

## 9. Understand common disk-space problems

### A filesystem is almost full

Start with:

```bash
df -h
du -sh /path/to/known/directory
```

Replace the path with a directory you are authorised to inspect.

### Many small files are consuming inodes

Start with:

```bash
df -i
```

Investigate the affected filesystem carefully. Large recursive file counts can be expensive, so narrow the search to known application directories.

### `df` and `du` disagree

Possible explanations include deleted files that a running process still has open, mount boundaries, permissions, filesystem metadata, or filesystems with special behaviour. Do not immediately delete more data. Investigate open deleted files with approved tools and appropriate privileges, and follow the system's operational runbook.

## 10. Safe cleanup principles

Before cleanup:
1. Identify the affected filesystem and mount point.
2. Determine which directories or files consume space.
3. Confirm whether the data is safe to remove and whether retention rules apply.
4. Check whether the files belong to an application, container runtime, database, or service.
5. Use the approved cleanup method and verify the result.

Avoid deleting files directly from `/var`, application data directories, container storage, or database directories just because they are large. Some files are managed by services and must be cleaned up using the service's supported procedures.

## 11. Hands-on exercises

Use your practice area or inspect your own machine without changing anything.

1. Run `df -h` and identify the filesystem containing your home directory.
2. Run `df -hT` and note the filesystem type.
3. Run `du -sh ~/linux-for-devops-practice`.
4. Run `df -i` and inspect inode usage.
5. Run `free -h` and identify the available memory.
6. Run `swapon --show`, if available.
7. Run `top` and identify the CPU and memory columns.
8. Explain one reason `df` and `du` may show different figures.
9. Write down the first three checks you would perform if a server reports that it cannot write a log file.

## 12. Knowledge check

1. What is the difference between `df` and `du`?
2. Why is `MemAvailable` often more useful than the `free` memory number alone?
3. What does `df -i` show?
4. What are inodes?
5. Why should you not delete a large file without checking which service uses it?
6. What does a high load average tell you—and what does it not tell you?

**Suggested answers**

1. `df` reports filesystem capacity and availability; `du` estimates usage by files and directories.
2. Linux uses RAM for reclaimable caches, so the `free` value alone can make healthy systems look more constrained than they are.
3. Inode usage and availability.
4. Filesystem structures that track objects such as files and directories.
5. The file may be required by an application or subject to retention rules; deletion may cause data loss or service failure.
6. It indicates queued/runnable work and some kinds of resource waiting, but it is not a direct CPU-percentage measurement and needs context.

## What comes next?

Continue to `07-networking-and-dns/network-troubleshooting.md` to learn how to check connectivity, DNS resolution, ports, and network routes.

---

**Safety note:** This lesson is for inspection and diagnosis. Do not resize filesystems, change swap, or delete system/application data without the required authorisation and a tested procedure.

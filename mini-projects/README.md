# Linux System Health Check

A beginner-friendly Bash mini-project for DevOps learners. This read-only script prints a quick snapshot of a Linux machine's hostname, current user, date/time, uptime, memory usage, and disk usage.

## What you'll learn

- How to write and run a Bash script
- How to check whether a command is available
- How to capture basic system information
- How to pass an optional command-line argument
- How to make scripts safer and easier to troubleshoot

## Project structure

```text
linux-system-health-check/
├── README.md
├── system-health.sh
└── examples/
    └── sample-output.txt
```

## Requirements

- A Linux environment (for example, Ubuntu, Debian, Fedora, or a Linux VM)
- Bash
- Common Linux utilities: `date`, `hostname`, `id`, `uptime`, `free`, and `df`

Some commands, such as `free`, may not be installed by default in very minimal containers. The script reports when a command is unavailable and continues where possible.

## Run the script

From this project directory:

```bash
chmod +x system-health.sh
./system-health.sh
```

To check disk usage for a specific mount point or directory:

```bash
./system-health.sh /home
```

The argument is passed to `df`. Use a path that exists on your machine. The default is `/`.

## Example output

The exact values depend on your machine. A sample is provided in [`examples/sample-output.txt`](examples/sample-output.txt).

## How it works

1. `date` prints the current date and time.
2. `hostname` shows the machine's hostname.
3. `id -un` prints the current username.
4. `uptime` reports how long the machine has been running and its load average when supported.
5. `free -h` shows memory usage in human-readable units.
6. `df -h` shows filesystem usage for the selected path.

The script checks for required commands before running them, so a missing utility does not stop the entire report.

## Troubleshooting

### `Permission denied`

Make the script executable:

```bash
chmod +x system-health.sh
```

Or run it with Bash directly:

```bash
bash system-health.sh
```

### `Command not found`

Check which utility is missing:

```bash
command -v free
command -v df
```

Install the relevant package using your distribution's package manager if needed. Package names vary by distribution.

### `No such file or directory` for a path

Check that the path exists:

```bash
ls -ld /home
```

Then pass a valid path to the script.

### The output differs from the sample

That is expected. Hostname, uptime, memory, disk capacity, and available space vary between machines.

## Practice challenges

1. Add a section that prints the kernel version using `uname -r`.
2. Add a section that shows the top five processes by CPU usage using `ps`.
3. Add a warning when the selected filesystem is above 80% usage. Test it carefully with the output format on your distribution.
4. Add an optional `--help` argument that prints usage instructions.
5. Save each report to a timestamped file under a directory you create for this purpose.

## Safety notes

- This script is intended to be read-only: it gathers information and does not change system configuration.
- Review scripts before running them, especially scripts copied from the internet.
- Do not commit real credentials, tokens, private hostnames, or sensitive infrastructure details in sample output.

## Commit suggestion

```text
feat: add Linux system health check mini-project
```

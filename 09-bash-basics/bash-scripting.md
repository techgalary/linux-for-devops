# Bash Scripting for DevOps

Bash scripts automate repeatable tasks such as checking service health, validating inputs, processing command output, and running small maintenance jobs. A good script should be readable, predictable, and safe to run.

> **Goal:** Learn script structure, variables, quoting, exit codes, conditions, loops, functions, and basic error handling.

## 1. Check your shell

```bash
echo "$SHELL"
bash --version
```

`$SHELL` often reports your configured login shell; it does not necessarily tell you which shell is running the current script. `bash --version` checks whether Bash is available.

Create a practice directory:

```bash
mkdir -p ~/linux-for-devops-practice/day9
cd ~/linux-for-devops-practice/day9
```

## 2. Your first Bash script

Create a file named `hello.sh`:

```bash
cat > hello.sh <<'EOF'
#!/usr/bin/env bash

echo "Hello from Bash!"
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
EOF
```

The first line is called a **shebang**. It tells the system which interpreter to use when executing the script directly.

Run it through Bash:

```bash
bash hello.sh
```

Or make it executable and run it directly:

```bash
chmod u+x hello.sh
./hello.sh
```

## 3. Variables and quoting

Create `variables.sh`:

```bash
cat > variables.sh <<'EOF'
#!/usr/bin/env bash

APP_NAME="sample-api"
ENVIRONMENT="development"

echo "Application: $APP_NAME"
echo "Environment: $ENVIRONMENT"
EOF
```

Run it:

```bash
bash variables.sh
```

Important rules:

- Do not put spaces around `=` when assigning a shell variable.
- Use double quotes around variable expansions in most cases.
- Use single quotes when you want text to be treated literally.
- Use descriptive variable names.

For example:

```bash
FILE_NAME="application log.txt"
printf 'File: %s\n' "$FILE_NAME"
```

Quoting `"$FILE_NAME"` keeps the value as one argument even though it contains a space.

## 4. Command substitution

Command substitution stores the output of a command:

```bash
CURRENT_DATE="$(date +%F)"
CURRENT_USER="$(whoami)"

printf 'Date: %s\n' "$CURRENT_DATE"
printf 'User: %s\n' "$CURRENT_USER"
```

Prefer `$(command)` over the older backtick form because it is easier to read and nest.

## 5. Positional arguments

Scripts can accept arguments from the command line.

Create `greet.sh`:

```bash
cat > greet.sh <<'EOF'
#!/usr/bin/env bash

NAME="${1:-friend}"
printf 'Hello, %s!\n' "$NAME"
EOF
```

Run it:

```bash
bash greet.sh
bash greet.sh Sowmya
```

- `$1` is the first positional argument.
- `$2` is the second positional argument.
- `$@` represents all positional arguments.
- `$#` is the number of positional arguments.

Use `"$@"` when passing arguments through to another command, because it preserves argument boundaries:

```bash
printf 'Argument: %s\n' "$@"
```

The expression `${1:-friend}` uses `friend` if the first argument is unset or empty.

## 6. Exit codes

Commands return an exit status. Conventionally, `0` means success and a non-zero value indicates failure or another condition.

```bash
true
echo "$?"

false
echo "$?"
```

`$?` contains the exit status of the most recently executed command. Read it immediately because the next command changes it.

Use the exit status to make scripts report failure accurately. Do not assume that every non-zero exit status means the same thing for every command.

## 7. Conditions with `if`

Create `check-file.sh`:

```bash
cat > check-file.sh <<'EOF'
#!/usr/bin/env bash

FILE_PATH="${1:-app.log}"

if [[ -f "$FILE_PATH" ]]; then
  echo "File exists: $FILE_PATH"
else
  echo "File not found: $FILE_PATH"
  exit 1
fi
EOF
```

Create a test file and run the script:

```bash
touch app.log
bash check-file.sh app.log
bash check-file.sh missing.log
```

In Bash:
- `[[ -f "$FILE_PATH" ]]` checks whether the path is a regular file.
- `[[ -d "$DIR_PATH" ]]` checks whether the path is a directory.
- `[[ -z "$VALUE" ]]` checks whether a string is empty.
- `[[ "$A" == "$B" ]]` compares strings.

Quote variables to avoid unwanted word splitting and pathname expansion.

## 8. Loops

### A `for` loop

```bash
for ENVIRONMENT in development staging production; do
  printf 'Checking environment: %s\n' "$ENVIRONMENT"
done
```

### Loop over files

```bash
for FILE_PATH in ./*.log; do
  [[ -e "$FILE_PATH" ]] || continue
  printf 'Found log: %s\n' "$FILE_PATH"
done
```

The existence check helps handle the case where no `.log` files match the pattern in the default Bash configuration. The exact behaviour of unmatched patterns can be affected by shell options.

### A `while` loop

```bash
COUNT=1

while [[ "$COUNT" -le 3 ]]; do
  printf 'Attempt %s\n' "$COUNT"
  COUNT=$((COUNT + 1))
done
```

Use loops when a task needs to repeat over a known list or until a condition changes.

## 9. Functions

Functions make repeated logic easier to maintain:

```bash
log_message() {
  local LEVEL="$1"
  shift
  printf '[%s] %s\n' "$LEVEL" "$*"
}

log_message INFO "Starting health check"
log_message WARN "Example warning"
```

`local` limits a variable's scope to the function. `shift` removes the first positional argument from the function's argument list. The example combines the remaining arguments into one message.

## 10. Pipes and command output

A pipe sends one command's output to another command:

```bash
grep 'ERROR' app.log | wc -l
```

Capture output in a variable:

```bash
ERROR_COUNT="$(grep -c 'ERROR' app.log)"
printf 'Error lines: %s\n' "$ERROR_COUNT"
```

A subtle point: `grep -c` usually exits with status `1` if no lines match, even though it prints `0`. Consider that behaviour when using `set -e` or checking exit statuses.

## 11. Safer script defaults

A common starting point for Bash scripts is:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

These options can help surface failures:
- `-e` asks Bash to exit on many unhandled command failures.
- `-u` treats expansion of unset variables as an error.
- `-o pipefail` makes a pipeline return a failure status if a command in it fails.

These options have exceptions and subtleties, especially inside conditions, functions, and pipelines. They are not a substitute for understanding each command's exit status or handling errors intentionally.

For a simple script, use explicit checks where the behaviour matters:

```bash
if ! command -v grep >/dev/null 2>&1; then
  echo "Error: grep is required" >&2
  exit 1
fi
```

`command -v` checks whether a command can be found. `>&2` sends the error message to standard error.

## 12. Mini-project: system health snapshot

This script reports basic information about the system. It is read-only and does not modify system configuration.

Create `system-health.sh`:

```bash
cat > system-health.sh <<'EOF'
#!/usr/bin/env bash
set -u

echo "===== System Health Snapshot ====="
printf 'Timestamp: '
date
printf 'Hostname: '
hostname
printf 'Current user: '
whoami

echo
echo "===== Uptime and Load ====="
uptime

echo
echo "===== Memory ====="
if command -v free >/dev/null 2>&1; then
  free -h
else
  echo "free command is not available"
fi

echo
echo "===== Filesystem Usage ====="
if command -v df >/dev/null 2>&1; then
  df -h
else
  echo "df command is not available"
fi

echo
echo "===== Snapshot Complete ====="
EOF
```

Run it:

```bash
bash system-health.sh
```

Optionally make it executable:

```bash
chmod u+x system-health.sh
./system-health.sh
```

The output varies by machine. On a system with many mounted filesystems, `df -h` may produce a long report. You can refine the script later to check specific mount points or report threshold warnings.

## 13. Debugging Bash scripts

Run a script with tracing:

```bash
bash -x hello.sh
```

This prints commands as Bash executes them, which can help identify logic errors. Be careful: tracing may reveal secrets if a script handles sensitive values.

Check a script's syntax without running it:

```bash
bash -n hello.sh
```

Use meaningful messages and send errors to standard error:

```bash
printf 'Error: input file is missing\n' >&2
```

For complex scripts, consider adding input validation, clear exit codes, logging, and tests.

## 14. Hands-on exercises

1. Write a script that prints your username, hostname, and current date.
2. Accept a name as an argument and print a greeting.
3. Write a script that checks whether a supplied file exists.
4. Loop over three environment names and print each one.
5. Create a function that prints a message with a severity label.
6. Use `bash -n` to check a script's syntax.
7. Run a script with `bash -x` and explain the output.
8. Run the system health snapshot and identify one metric you would investigate if it looked unusual.

## 15. Knowledge check

1. What is a shebang?
2. Why should shell variables usually be quoted?
3. What does `$?` contain?
4. What does `"$@"` preserve?
5. What is the purpose of a function?
6. What do `set -u` and `pipefail` help detect?
7. Why can `bash -x` be risky when secrets are involved?

**Suggested answers**

1. The first line that specifies the interpreter for direct execution.
2. Quoting prevents unwanted word splitting and pathname expansion.
3. The exit status of the most recently executed command.
4. The original argument boundaries when passing positional arguments through.
5. It packages reusable logic into a named block.
6. `-u` flags unset-variable expansions; `pipefail` propagates failures from commands within a pipeline.
7. Trace output can print sensitive values and command arguments.

## What comes next?

Continue to the `exercises/` folder to build short challenges from the lessons, then use `mini-projects/` for larger, practical tasks such as a system health check.

---

**Safety note:** Test scripts in your own practice directory first. Avoid running unfamiliar scripts with `sudo`, and do not print credentials or tokens to terminal output or logs.

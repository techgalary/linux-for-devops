#!/usr/bin/env bash
# Linux System Health Check
# Read-only snapshot of basic system information.

set -u

mount_point="${1:-/}"

section() {
  printf '\n=== %s ===\n' "$1"
}

run_if_available() {
  local command_name="$1"
  shift

  if command -v "$command_name" >/dev/null 2>&1; then
    "$command_name" "$@"
  else
    printf 'Skipped: command "%s" is not installed or not in PATH.\n' "$command_name"
  fi
}

if [[ ! -e "$mount_point" ]]; then
  printf 'Error: path does not exist: %s\n' "$mount_point" >&2
  printf 'Usage: %s [mount-point-or-directory]\n' "$0" >&2
  exit 2
fi

printf 'Linux System Health Check\n'
printf '=========================\n'

section "Date and time"
run_if_available date '+%Y-%m-%d %H:%M:%S %Z'

section "Hostname"
run_if_available hostname

section "Current user"
run_if_available id -un

section "Uptime"
run_if_available uptime

section "Memory usage"
run_if_available free -h

section "Disk usage for: $mount_point"
run_if_available df -h -- "$mount_point"

printf '\nHealth snapshot complete.\n'

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an Ansible role for installing and configuring auditship, a tool that ships Linux audit logs to Fluentd endpoints. The role downloads the latest auditship binary from GitLab, configures it as an auditd plugin, and sets up log rotation.

## Architecture

- **Entry point**: `tasks/main.yml` - Checks for existing auditship binary and conditionally includes auditship installation
- **Main installation**: `tasks/auditship.yml` - Handles the complete auditship setup workflow
- **Configuration template**: `templates/auditship.plugin.conf.j2` - Auditd plugin configuration
- **Role metadata**: `meta/main.yml` - Defines supported platforms (Ubuntu/Debian) and dependencies
- **Default variables**: `defaults/main.yml` - Contains `auditship_force_install` flag

## Installation Workflow

The role follows this sequence:
1. Queries GitLab API for latest auditship release version
2. Downloads compressed binary from GitLab packages
3. Extracts and installs to `/usr/local/bin/auditship`
4. Configures auditd plugin in `/etc/audit/plugins.d/auditship.conf`
5. Downloads and installs logrotate configuration

## Key Variables

- `auditship_fluent_url`: Fluentd endpoint URL (default: `fluent://127.0.0.1:24224`)
- `auditship_force_install`: Forces reinstallation even if binary exists (default: `false`)

## Common Development Tasks

### Setup
```bash
# Install dependencies
make install
# or manually:
pip install -r requirements.txt
```

### Testing
```bash
# Run all molecule tests (default scenario)
make test
# or: molecule test

# Run syntax check only
make syntax
# or: molecule syntax

# Test specific scenario
molecule test -s default

# Create test instances (for debugging)
molecule create
molecule converge
molecule verify
molecule destroy
```

### Linting
```bash
# Run all linters
make lint

# Individual linters:
ansible-lint .
yamllint .
markdownlint .
```

### Molecule Test Platforms
- Ubuntu 24.04
- Debian 11  
- Debian 12

### Debugging Tests
```bash
# Create and keep instances for debugging
molecule converge
molecule login -h ubuntu-24.04

# Clean up test artifacts
make clean
```

## External Dependencies

- GitLab API access for version checking and binary download
- Internet connectivity for downloading auditship binary and logrotate config
- Root privileges for installing to `/usr/local/bin/` and configuring auditd
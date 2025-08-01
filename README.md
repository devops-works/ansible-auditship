# Ansible Role: auditship

[![CI](https://github.com/devops-works/ansible-auditship/workflows/CI/badge.svg)](https://github.com/devops-works/ansible-auditship/actions?query=workflow%3ACI)

An Ansible role for installing and configuring [auditship](https://gitlab.com/devopsworks/tools/auditship), a tool that
ships Linux audit logs to Fluentd endpoints in real-time.

## Features

- Automatically downloads the latest auditship binary from GitLab releases
- Configures auditship as an auditd plugin for real-time log shipping
- Sets up log rotation to prevent disk space issues
- Supports multiple Linux distributions (Ubuntu, Debian)
- Idempotent installation with force reinstall option

## Requirements

- Ansible >= 2.4
- Target systems must have `auditd` installed and running
- Internet connectivity for downloading auditship binary and configuration files
- Root privileges on target systems

## Role Variables

### Required Variables

None. All variables have sensible defaults.

### Optional Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `auditship_force_install` | `false` | Forces reinstallation even if binary exists |
| `auditship_tag` | `auditd` | Tag to apply to audit logs |
| `auditship_outputs` | `["-", "/var/log/auditship.json"]` | Array of output destinations (stdout and file) |
| `auditship_log_file` | `/var/log/auditship.log` | Location of auditship log file |
| `auditship_log_level` | `info` | Logging level (debug, info, warn, error) |
| `auditship_buffer_size` | `10000` | Buffer size for batching audit events |
| `auditship_retry_interval` | `30` | Retry interval in seconds for failed deliveries |
| `auditship_max_retry_attempts` | `10` | Maximum number of retry attempts |
| `auditship_metrics_enabled` | `false` | Enable metrics endpoint for monitoring |
| `auditship_metrics_bind_address` | `127.0.0.1` | Bind address for metrics endpoint |
| `auditship_metrics_port` | `9090` | Port for metrics endpoint |
| `auditship_metrics_path` | `/metrics` | HTTP path for metrics endpoint |

### Example Variable Configuration

```yaml
auditship_force_install: true
auditship_tag: "security-audit"
auditship_outputs:
  - "-"                           # stdout
  - "/var/log/auditship.json"     # local file
  - "fluent://log-server.company.com:24224"  # fluentd endpoint
auditship_log_file: "/var/log/auditship.log"
auditship_log_level: "debug"
auditship_buffer_size: 5000       # smaller buffer for high-frequency logs
auditship_retry_interval: 60      # retry every minute
auditship_max_retry_attempts: 5   # fail after 5 attempts
auditship_metrics_enabled: true   # enable monitoring
auditship_metrics_bind_address: "0.0.0.0"  # expose metrics externally
auditship_metrics_port: 8080      # custom metrics port
auditship_metrics_path: "/stats"  # custom metrics path
```

## Dependencies

None.

## Example Playbook

### Basic Usage

```yaml
- hosts: servers
  become: true
  roles:
    - devopsworks.auditship
```

### With Custom Configuration

```yaml
- hosts: servers
  become: true
  vars:
    auditship_tag: "security-audit"
    auditship_outputs:
      - "-"                           # stdout
      - "/var/log/auditship.json"     # local file  
      - "fluent://log-server.company.com:24224"  # fluentd endpoint
    auditship_log_level: "debug"
    auditship_buffer_size: 5000       # smaller buffer for high-frequency logs
    auditship_retry_interval: 60      # retry every minute
    auditship_max_retry_attempts: 5   # fail after 5 attempts
    auditship_metrics_enabled: true   # enable monitoring
    auditship_metrics_bind_address: "0.0.0.0"  # expose metrics externally
    auditship_metrics_port: 8080      # custom metrics port
    auditship_metrics_path: "/stats"  # custom metrics path
  roles:
    - devopsworks.auditship
```

### Force Reinstallation

```yaml
- hosts: servers
  become: true
  vars:
    auditship_force_install: true
  roles:
    - devopsworks.auditship
```

## Installation

### From Ansible Galaxy

```bash
ansible-galaxy install devopsworks.auditship
```

### From Git Repository

```bash
ansible-galaxy install git+https://github.com/devops-works/ansible-auditship.git
```

## What This Role Does

1. **Version Detection**: Queries GitLab API to find the latest auditship release
2. **Binary Download**: Downloads the compressed auditship binary for Linux AMD64
3. **Installation**: Extracts and installs the binary to `/usr/local/bin/auditship`
4. **Plugin Configuration**: Creates auditd plugin configuration in `/etc/audit/plugins.d/auditship.conf`
5. **Main Configuration**: Creates main auditship configuration file at `/etc/auditship.conf`
6. **Log Rotation**: Downloads and installs logrotate configuration to `/etc/logrotate.d/auditship`

## File Locations

- **Binary**: `/usr/local/bin/auditship`
- **Plugin Config**: `/etc/audit/plugins.d/auditship.conf`
- **Main Config**: `/etc/auditship.conf`
- **Log Rotation**: `/etc/logrotate.d/auditship`

## Supported Platforms

- Ubuntu (all versions)
- Debian (all versions)

## Testing

This role includes comprehensive testing using Molecule with Podman driver.

### Prerequisites

```bash
pip install -r requirements.txt
```

### Run Tests

```bash
# Run all tests
make test

# Run linting only
make lint

# Run syntax check
make syntax
```

### Test Platforms

- Ubuntu 24.04
- Debian 11
- Debian 12

## Development

### Setup Development Environment

1. Clone the repository
2. Install dependencies: `make install`
3. Run tests: `make test`

### Available Make Targets

- `make help` - Show available commands
- `make install` - Install Python dependencies
- `make lint` - Run all linting tools
- `make test` - Run molecule tests
- `make clean` - Clean up test artifacts
- `make syntax` - Check Ansible syntax

## Troubleshooting

### Common Issues

1. **Internet Connectivity**: Ensure target systems can reach GitLab for downloading binaries
2. **Auditd Service**: Verify auditd is installed and running before applying this role
3. **Permissions**: Role requires root privileges for installation and configuration

### Verification

After running the role, verify installation:

```bash
# Check binary exists and is executable
ls -la /usr/local/bin/auditship

# Test auditship version
/usr/local/bin/auditship -version

# Verify plugin configuration
cat /etc/audit/plugins.d/auditship.conf

# Verify main configuration
cat /etc/auditship.conf

# Check auditd is using the plugin
sudo service auditd status
```

## License

MIT

## Author Information

This role was created by [DevopsWorks](https://devopsworks.io/).

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite: `make test`
6. Submit a pull request

## Links

- [auditship project](https://gitlab.com/devopsworks/tools/auditship)
- [Issue tracker](https://github.com/devops-works/ansible-auditship/issues)
- [DevopsWorks](https://devopsworks.io/)

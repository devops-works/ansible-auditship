# ansible-auditship

Installs auditship (https://gitlab.com/devopsworks/tools/auditship) to ship
audit logs to Fluentd.

This role does not check if v is already installed and overrides
existing binary (no way to check version in v yet).

## Variables

- `auditship_fluent_url`: URL to Fluentd endpoint (default: `fluent://127.0.0.1:24224`)

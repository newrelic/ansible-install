<a href="https://opensource.newrelic.com/oss-category/#community-project"><picture><source media="(prefers-color-scheme: dark)" srcset="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/dark/Community_Project.png"><source media="(prefers-color-scheme: light)" srcset="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png"><img alt="New Relic Open Source community project banner." src="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png"></picture></a>

# New Relic Ansible Role

`newrelic.newrelic_install` is an [Ansible Role](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html) that will help you scale your New Relic Observability efforts. It uses the [New Relic CLI](https://github.com/newrelic/newrelic-cli) and [New Relic Open Installation repository](https://github.com/newrelic/open-install-library) to achieve this.

**Note: Installing specific versions of an agent is not supported, this role will always install latest released version of a New Relic agent.**

Please, check out the sections below for details on installation, how to get started, role's variables, dependencies and an example ansible `playbook` showcasing this role's usage.

If you need help with Ansible for Windows OS, take a look at [Setting up a Windows Host](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html), from the [Ansible Documentation](https://docs.ansible.com/ansible/latest/) site.

## Installation

### Ansible Galaxy

```
ansible-galaxy install newrelic.newrelic_install
```

[Link to Galaxy](https://galaxy.ansible.com/ui/standalone/roles/newrelic/newrelic_install/)

Make sure you have `ansible.windows` and `ansible.utils` if they are not already installed:

```
ansible-galaxy collection install ansible.windows ansible.utils
```

### Manual

If you want to use a local copy of the role, clone the repo and run `make` in the project root to copy this repo to `~/.ansible/roles/newrelic.newrelic_install`, enabling the role to behave as though it were installed from Galaxy.

## Getting Started

After installing, include the `newrelic.newrelic_install` role in a new or existing playbook. For example:

```
- name: Install New Relic
  hosts: all
  roles:
    - role: newrelic.newrelic_install
      vars:
        targets:
          - infrastructure
          - logs
          - apm-php
        tags:
          foo: bar
  environment:
    NEW_RELIC_API_KEY: <API key>
    NEW_RELIC_ACCOUNT_ID: <Account ID>
    NEW_RELIC_REGION: <Region>
```

## Variables

### Role variables

#### `targets` (Required)

List of targeted installs to run on hosts. Available options are:

- `infrastructure` (Linux & Windows)
- `logs` (Linux & Windows)
- `apm-php` (Linux)
- `apm-nodejs` (Linux)
- `apm-dotnet` (Linux & Windows)
- `apm-java` (Linux)
- `apache` (Linux)
- `mssql` (Windows)
- `mssql-otel` (Windows, Ubuntu, RHEL) — self-hosted, SQL Server Authentication
- `mssql-otel-rds` (Windows, Ubuntu, RHEL) — AWS RDS SQL Server, SQL Server Authentication
- `mssql-otel-winauth` (Windows) — self-hosted, Windows Domain Auth or gMSA
- `mssql-otel-rds-winauth` (Windows) — AWS RDS SQL Server (AD-domain-joined), Windows Domain Auth or gMSA
- `mysql` (Linux)
- `mysql-otel` (Linux, self-hosted MySQL, Debian/Ubuntu or RHEL/CentOS)
- `mysql-otel-rds` (Linux, MySQL/Aurora on AWS RDS, collector host on Debian/Ubuntu or RHEL/CentOS)
- `postgresql-otel` (Linux, self-hosted PostgreSQL, Debian/Ubuntu or RHEL/CentOS)
- `postgresql-otel-rds` (Linux, PostgreSQL/Aurora on AWS RDS, collector host on Debian/Ubuntu or RHEL/CentOS)
- `nginx` (Linux)
- `oracle-otel` (Linux, self-hosted Oracle on RHEL/OEL)
- `oracle-otel-rds` (Linux, Oracle on AWS RDS, collector host on Debian/Ubuntu or RHEL/CentOS/OEL)

Important Notes:

- the `logs` target requires `infrastructure`, and an error will be thrown if `logs` is specified without `infrastructure`.
- the `apm-nodejs` agent installation is supported only for apps managed by [PM2](https://pm2.keymetrics.io/). To install the agent using a package manager such as `npm` or `yarn` or via other installation paths, please reference our [docs](https://docs.newrelic.com/docs/apm/agents/nodejs-agent/installation-configuration/install-nodejs-agent/).
- the `apm-dotnet` agent installation for Windows is supported only for apps hosted by [IIS](https://www.iis.net/). Linux installations are only supported for .NET applications which run as a `systemd` service.
- the `apm-java` agent installation supports Java running in Tomcat, Wildfly/Jboss, and Jetty (standalone). Note that this is a limited Java APM installation which instruments certain Java app servers via dynamic attachment using New Relic's Java introspector. More details [here](https://github.com/newrelic/open-install-library/blob/main/docs/guided-java.md)
- the `mysql-otel*` and `postgresql-otel*` targets are separate integrations from `mysql`: they monitor the database via the NRDOT (New Relic distribution of the OpenTelemetry) Collector instead of a classic on-host integration, do not require the infrastructure agent, and use their own `NR_CLI_MYSQL_*` / `NR_CLI_POSTGRES_*` environment variables (see below) rather than `mysql`'s `NEW_RELIC_MYSQL_*` variables.
- the `mssql-otel*` targets are separate integrations from `mssql`: they monitor SQL Server via the NRDOT (New Relic distribution of the OpenTelemetry) Collector instead of the classic on-host integration, do not require the infrastructure agent, and use their own `NR_CLI_MSSQL_*` environment variables (see below) rather than `mssql`'s `NEW_RELIC_MSSQL_*` variables.
- the following integrations require the infrastructure agent to be installed:
  - apm-java
  - apache
  - mssql
  - mysql
  - nginx

#### `tags` (Optional)

Key-value pairs of tags passed to the installation.

#### `install_timeout_seconds` (Optional)

Sets timeout for installation task. Overrides the default timeout of 600s.

#### `verbosity` (Optional)

Verbosity options for the installation (`debug` or `trace`). Writes verbose output to a log file on the host.

### Defaults

Set in [defaults/main.yml](https://github.com/newrelic/ansible-install/blob/main/defaults/main.yml):

- `cli_install_url`
- `cli_install_download_location`
- `target_name_map`
- `verbosity_on_log_file_path_linux`
- `verbosity_on_log_file_path_windows`
- `default_install_timeout_seconds`

### Environment variables

Values are set under the [`environment`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_environment.html) keyword in your playbook:

- `NEW_RELIC_API_KEY` (required)
- `NEW_RELIC_ACCOUNT_ID` (required)
- `NEW_RELIC_REGION` (optional: 'US', 'EU', or 'JP', default 'US')

Additionally, an optional `HTTPS_PROXY` variable can be set to enable a proxy for your installation.

#### `apm-php`:

- `NEW_RELIC_APPLICATION_NAME` (optional) The name of the PHP application to instrument. This name will be listed under New Relic's `APM & Services`. If omitted, defaults to `PHP Application`.

#### `apache`:

- `NEW_RELIC_APACHE_STATUS_URL` (optional) The URL to check the Apache web server status. This is used to ensure that an Apache web server is running on the host and is in a healthy state before attempting the installation of the Apache On-Host Integration. Defaults to: `http://127.0.0.1/server-status?auto`

#### `mssql`:

- `NEW_RELIC_MSSQL_DB_HOSTNAME` (optional) Hostname or IP where MS SQL server is running. Defaults to discovered hostname if unspecified.
- `NEW_RELIC_MSSQL_DB_PORT` (optional) Port on which MS SQL server is listening. Defaults to `1433`
- `NEW_RELIC_MSSQL_DB_USERNAME` (optional) Username for accessing the MS SQL server. Defaults to `newrelic`. If using a domain user, use the syntax `domain\user`
- `NEW_RELIC_MSSQL_DB_PASSWORD` (optional) Password for the given SQL or Domain user. If no password is provided, a random password will be generated.
- `NEW_RELIC_MSSQL_SQL_USERNAME` (optional) Optional credential override passed to `sqlcmd` when creating the SQL user specified by `NEW_RELIC_MSSQL_DB_USERNAME`. If omitted, the default login username will be used.
- `NEW_RELIC_MSSQL_SQL_PASSWORD` (optional) Optional credential override passed to `sqlcmd` when creating the SQL user specified by `NEW_RELIC_MSSQL_DB_USERNAME`. If omitted, the default login password will be used.
- `NEW_RELIC_MSSQL_ENABLE_BUFFER_METRICS` (optional) Enable collection of buffer pool metrics. Defaults to true
- `NEW_RELIC_MSSQL_ENABLE_RESERVE_METRICS` (optional) Enable collection of database partition reserve space. Defaults to true

#### `mssql-otel` (self-hosted, SQL Server Authentication):

- `NR_CLI_MSSQL_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_MSSQL_SERVER` (optional) SQL Server host. Defaults to `localhost`
- `NR_CLI_MSSQL_PORT` (optional) SQL Server port. Defaults to `1433`
- `NR_CLI_MSSQL_SA_PASSWORD` (**required**) The SQL Server `sa` password, used once to create the monitoring login
- `NR_CLI_MSSQL_LOGIN_NAME` (optional) Monitoring username to create. Defaults to `newrelic`

#### `mssql-otel-rds` (AWS RDS SQL Server, SQL Server Authentication):

- `NR_CLI_MSSQL_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_MSSQL_SERVER` (**required**) The RDS SQL Server endpoint. Unlike the self-hosted recipe, there is no default.
- `NR_CLI_MSSQL_PORT` (optional) SQL Server port. Defaults to `1433`
- `NR_CLI_MSSQL_MASTER_USER` (**required**) The RDS master username, used once to create the monitoring login.
- `NR_CLI_MSSQL_MASTER_PASSWORD` (**required**) The RDS master password.
- `NR_CLI_MSSQL_LOGIN_NAME` (optional) Monitoring username to create. Defaults to `newrelic`

#### `mssql-otel-winauth` (self-hosted, Windows Domain Auth or gMSA):

- `NR_CLI_MSSQL_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_MSSQL_AUTH_MODE` (optional) `1` for Windows Domain Auth or `2` for gMSA. Defaults to `1`
- `NR_CLI_MSSQL_SERVER` (optional) SQL Server host. Defaults to `localhost`
- `NR_CLI_MSSQL_PORT` (optional) SQL Server port. Defaults to `1433`
- `NR_CLI_MSSQL_WIN_ACCOUNT` / `NR_CLI_MSSQL_WIN_PASSWORD` (**required** if `NR_CLI_MSSQL_AUTH_MODE` is `1`) Windows domain account (`DOMAIN\username`) and password to grant permissions to and run the collector service as
- `NR_CLI_MSSQL_GMSA_ACCOUNT` (**required** if `NR_CLI_MSSQL_AUTH_MODE` is `2`) gMSA account (`DOMAIN\gMSAName$`) to grant permissions to

#### `mssql-otel-rds-winauth` (AWS RDS SQL Server joined to an AWS Managed AD domain, Windows Domain Auth or gMSA):

- `NR_CLI_MSSQL_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_MSSQL_AUTH_MODE` (optional) `1` for Windows Domain Auth or `2` for gMSA. Defaults to `1`
- `NR_CLI_MSSQL_SERVER` (**required**) The RDS SQL Server endpoint. Unlike the self-hosted recipe, there is no default.
- `NR_CLI_MSSQL_PORT` (optional) SQL Server port. Defaults to `1433`
- `NR_CLI_MSSQL_WIN_ACCOUNT` / `NR_CLI_MSSQL_WIN_PASSWORD` (**required** if `NR_CLI_MSSQL_AUTH_MODE` is `1`) Windows domain account (`DOMAIN\username`) and password to grant permissions to and run the collector service as
- `NR_CLI_MSSQL_GMSA_ACCOUNT` (**required** if `NR_CLI_MSSQL_AUTH_MODE` is `2`) gMSA account (`DOMAIN\gMSAName$`) to grant permissions to

#### `mysql`:

- `NEW_RELIC_MYSQL_PORT` (optional) Defaults to `3306` if unspecified.
- `NEW_RELIC_MYSQL_USERNAME` (optional) Defaults to `newrelic` if no other is specified. This is the username that the `mysql` integration will setup and will also set in the integration's configuration file (e.g.: `mysql-config.yml`) for data reporting purposes. See more in [MySQL integration](https://docs.newrelic.com/install/mysql/).
- `NEW_RELIC_MYSQL_PASSWORD` (optional) The password for the user specified in `NEW_RELIC_MYSQL_USERNAME`. See more in [MySQL integration](https://docs.newrelic.com/install/mysql/).
- `NEW_RELIC_MYSQL_ROOT_PASSWORD` (required) The `mysql` integration needs to connect to `mysql` to create the appropriate credentials.

#### `mysql-otel` (self-hosted):

- `NR_CLI_MYSQL_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_MYSQL_SERVER` (optional) MySQL host. Defaults to `localhost`
- `NR_CLI_MYSQL_PORT` (optional) MySQL port. Defaults to `3306`
- `NR_CLI_MYSQL_ROOT_PASSWORD` (**required**) The MySQL root password, used once to create the monitoring user
- `NR_CLI_MYSQL_LOGIN_NAME` (optional) Monitoring username to create. Defaults to `newrelic`

#### `mysql-otel-rds` (AWS RDS/Aurora MySQL):

- `NR_CLI_MYSQL_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_MYSQL_SERVER` (**required**) The RDS/Aurora MySQL endpoint. Unlike the self-hosted recipe, there is no default.
- `NR_CLI_MYSQL_PORT` (optional) MySQL port. Defaults to `3306`
- `NR_CLI_MYSQL_MASTER_USER` (**required**) The RDS master username, used once to create the monitoring user.
- `NR_CLI_MYSQL_MASTER_PASSWORD` (**required**) The RDS master password.
- `NR_CLI_MYSQL_LOGIN_NAME` (optional) Monitoring username to create. Defaults to `newrelic`

#### `postgresql-otel` (self-hosted):

- `NR_CLI_POSTGRES_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_POSTGRES_SERVER` (optional) PostgreSQL host. Defaults to `localhost`
- `NR_CLI_POSTGRES_PORT` (optional) PostgreSQL port. Defaults to `5432`
- `NR_CLI_POSTGRES_SUPERUSER_PASSWORD` (**required**) The PostgreSQL superuser (`postgres`) password, used once to create the monitoring role
- `NR_CLI_POSTGRES_LOGIN_NAME` (optional) Monitoring username to create. Defaults to `newrelic`
- `NR_CLI_POSTGRES_DATABASES` (**required**) Comma-separated list of database names to monitor. The recipe requires at least one.

#### `postgresql-otel-rds` (AWS RDS/Aurora PostgreSQL):

- `NR_CLI_POSTGRES_CONFIG_PRESET` (optional) `1` for Standard or `2` for Full-feature metric collection. Defaults to `1`
- `NR_CLI_POSTGRES_SERVER` (**required**) The RDS/Aurora PostgreSQL endpoint. Unlike the self-hosted recipe, there is no default.
- `NR_CLI_POSTGRES_PORT` (optional) PostgreSQL port. Defaults to `5432`
- `NR_CLI_POSTGRES_MASTER_USER` (**required**) The RDS master username, used once to create the monitoring role.
- `NR_CLI_POSTGRES_MASTER_PASSWORD` (**required**) The RDS master password.
- `NR_CLI_POSTGRES_LOGIN_NAME` (optional) Monitoring username to create. Defaults to `newrelic`
- `NR_CLI_POSTGRES_DATABASES` (**required**) Comma-separated list of database names to monitor. The recipe requires at least one.
#### `oracle-otel` (self-hosted Oracle, RHEL/OEL):

- `NR_CLI_ORACLE_HOST` (optional) Hostname or IP where Oracle is running. Defaults to `localhost`.
- `NR_CLI_ORACLE_PORT` (optional) Port on which Oracle is listening. Defaults to `1521`.
- `NR_CLI_ORACLE_SSH_USER` (optional) SSH user for the Oracle Database host, used once to create the monitoring user and grant privileges via OS-authenticated SYSDBA access. Defaults to `opc`.
- `NR_CLI_ORACLE_CONTAINER_TYPE` (optional) Oracle container type: `1` for CDB (monitor all PDBs) or `2` for a single PDB. Defaults to `1`.
- `NR_CLI_ORACLE_PDB_NAME` (optional) PDB name. Only used when `NR_CLI_ORACLE_CONTAINER_TYPE` is `2`.
- `NR_CLI_ORACLE_LOGIN_NAME` (optional) Monitoring username (created as `c##<name>` in CDB mode). Defaults to `newrelic`.
- `NR_CLI_ORACLE_LOGIN_PASSWORD` (**required**) Password for the monitoring login. The recipe allows leaving this blank to auto-generate a password, but that only works in the CLI's interactive prompt flow — this role installs non-interactively, so a real value must be supplied.
- `NR_CLI_ORACLE_SERVICE_NAME` (**required**) CDB or PDB service name for the collector connection.
- `NR_CLI_ORACLE_CONFIG_PRESET` (optional) `1` for database metrics only, `2` for host + database metrics. Defaults to `1`.

#### `oracle-otel-rds` (Oracle on AWS RDS):

- `NR_CLI_ORACLE_HOST` (**required**) The RDS Oracle endpoint. Unlike the self-hosted recipe, there is no default.
- `NR_CLI_ORACLE_PORT` (optional) Port on which Oracle is listening. Defaults to `1521`.
- `NR_CLI_ORACLE_ADMIN_USER` (**required**) The RDS master username, used once to create the monitoring user and grant privileges.
- `NR_CLI_ORACLE_ADMIN_PASSWORD` (**required**) The RDS master password.
- `NR_CLI_ORACLE_LOGIN_NAME` (optional) Monitoring username. Defaults to `newrelic`.
- `NR_CLI_ORACLE_LOGIN_PASSWORD` (**required**) Password for the monitoring login. As with `oracle-otel`, the recipe's auto-generate-if-blank behavior only applies to interactive installs, so a real value must be supplied here.
- `NR_CLI_ORACLE_SERVICE_NAME` (**required**) The RDS DB service name for the collector connection.
- `NR_CLI_ORACLE_CONFIG_PRESET` (optional) `1` for database metrics only, `2` for host + database metrics. Defaults to `1`.

See [ansible's remote environment](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_environment.html) for more info.

## Versions Compatibility

- Ansible: Tested with the Ansible Core 2.13 and 2.14. Ansible Core versions before 2.10 are not supported.
- Python: Tested with Python 3.10.

## Dependencies

Python requirements: [requirements.txt](https://github.com/newrelic/ansible-install/blob/main/requirements.txt)

Ansible requirements: [requirements.yml](https://github.com/newrelic/ansible-install/blob/main/requirements.yml)

## Example Playbook

```
- name: Install New Relic
  hosts: all
  roles:
    - role: newrelic.newrelic_install
      vars:
        targets:
          - infrastructure
          - logs
          - apm-php
        tags:
          foo: bar
        install_timeout_seconds: 1000
        verbosity: debug
  environment:
    NEW_RELIC_API_KEY: <API key>
    NEW_RELIC_ACCOUNT_ID: <Account ID>
    NEW_RELIC_REGION: <Region>
    NEW_RELIC_APPLICATION_NAME: "My Application"
    HTTPS_PROXY: "http://my.proxy:8888"
```

- Find your user key: [API keys UI](https://one.newrelic.com/launcher/api-keys-ui.api-keys-launcher)

- Find your account ID: [Account ID documentation](https://docs.newrelic.com/docs/accounts/accounts-billing/account-structure/account-id/)

## Add a new target support to `newrelic_install` ansible role
For developers who want to add support for a new target to the `newrelic_install` ansible role, please refer to [this](https://github.com/newrelic/ansible-install/blob/main/defaults/developers-guide.md) documentation.

## Support

New Relic hosts and moderates an online forum where customers can interact with
New Relic employees as well as other customers to get help and share best
practices. Like all official New Relic open source projects, there's a related
Community topic in the New Relic Explorers Hub. You can find this project's
topic/threads here:

- [New Relic Documentation](https://docs.newrelic.com): Comprehensive guidance for using our platform
- [New Relic Community](https://forum.newrelic.com): The best place to engage in troubleshooting questions
- [New Relic Developer](https://developer.newrelic.com/): Resources for building a custom observability applications
- [New Relic University](https://learn.newrelic.com/): A range of online training for New Relic users of every level
- [New Relic Technical Support](https://support.newrelic.com/) 24/7/365 ticketed support. Read more about our [Technical Support Offerings](https://docs.newrelic.com/docs/licenses/license-information/general-usage-licenses/support-plan).

## Contribute

We encourage your contributions to improve the `newrelic.newrelic_install` ansible role! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](https://github.com/newrelic/ansible-install/security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

If you would like to contribute to this project, review [these guidelines](https://github.com/newrelic/ansible-install/blob/main/CONTRIBUTING.md).

To all contributors, we thank you! Without your contribution, this project would not be what it is today.

## License

This project is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.

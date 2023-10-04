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
- `mysql` (Linux)
- `nginx` (Linux)

Important Notes:

- the `logs` target requires `infrastructure`, and an error will be thrown if `logs` is specified without `infrastructure`.
- the `apm-nodejs` agent installation is supported only for apps managed by [PM2](https://pm2.keymetrics.io/). To install the agent using a package manager such as `npm` or `yarn` or via other installation paths, please reference our [docs](https://docs.newrelic.com/docs/apm/agents/nodejs-agent/installation-configuration/install-nodejs-agent/).
- the `apm-dotnet` agent installation for Windows is supported only for apps hosted by [IIS](https://www.iis.net/). Linux installations are only supported for .NET applications which run as a `systemd` service.
- the `apm-java` agent installation supports Java running in Tomcat, Wildfly/Jboss, and Jetty (standalone). Note that this is a limited Java APM installation which instruments certain Java app servers via dynamic attachment using New Relic's Java introspector. More details [here](https://github.com/newrelic/open-install-library/blob/main/docs/guided-java.md)
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
- `NEW_RELIC_REGION` (optional: 'US' or 'EU', default 'US')

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

#### `mysql`:

- `NEW_RELIC_MYSQL_PORT` (optional) Defaults to `3306` if unspecified.
- `NEW_RELIC_MYSQL_USERNAME` (optional) Defaults to `newrelic` if no other is specified. This is the username that the `mysql` integration will setup and will also set in the integration's configuration file (e.g.: `mysql-config.yml`) for data reporting purposes. See more in [MySQL integration](https://docs.newrelic.com/install/mysql/).
- `NEW_RELIC_MYSQL_PASSWORD` (optional) The password for the user specified in `NEW_RELIC_MYSQL_USERNAME`. See more in [MySQL integration](https://docs.newrelic.com/install/mysql/).
- `NEW_RELIC_MYSQL_ROOT_PASSWORD` (required) The `mysql` integration needs to connect to `mysql` to create the appropriate credentials.

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

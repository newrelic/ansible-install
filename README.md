[![Community header](https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png)](https://opensource.newrelic.com/oss-category/#community-project)

# New Relic Ansible Role

`newrelic.newrelic_install` is an [Ansible Role](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html) that will help you scale your New Relic Observability efforts. It uses the [New Relic CLI](https://github.com/newrelic/newrelic-cli) and [New Relic Open Installation repository](https://github.com/newrelic/open-install-library) to achieve this.

Currently, we have included Linux and Windows support for New Relic's Infrastructure and Logs integrations, with more agents and integrations following in the near future.

**Note: Installing specific versions of an agent is not supported, this role will always install latest released version of a New Relic agent.**

Please, check out the sections below for details on installation, how to get started, role's variables, dependencies and an example ansible `playbook` showcasing this role's usage.

If you need help with Ansible for Windows OS, take a look at [Setting up a Windows Host](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html), from the [Ansible Documentation](https://docs.ansible.com/ansible/latest/) site.

## Installation

### Ansible Galaxy

```
ansible-galaxy install newrelic.newrelic_install
```

[Link to Galaxy](https://galaxy.ansible.com/newrelic/newrelic_install)

### Manual

Run `make` in the project root to copy this repo to `~/.ansible/roles/newrelic.newrelic_install`, enabling the role to behave as though it were installed from Galaxy.

## Getting Started

After installing, include the `newrelic.newrelic_install` role in a new or existing playbook. For example:

```
- name: Install New Relic infrastructure and logs
  hosts: all
  roles:
    - role: newrelic.newrelic_install
  environment:
    NEW_RELIC_API_KEY: <API key>
    NEW_RELIC_ACCOUNT_ID: <Account ID>
    NEW_RELIC_REGION: <Region>
```

## Variables

### Environment variables

Values are set under the `environment` keyword in your playbook:

- `NEW_RELIC_API_KEY` (required)
- `NEW_RELIC_ACCOUNT_ID` (required)
- `NEW_RELIC_REGION` (optional: 'US' or 'EU', default 'US')

Additionally, an optional `HTTPS_PROXY` variable can be set to enable a proxy for your installation.

See [ansible's remote environment](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_environment.html) for more info.

### Role variables

#### `targets` (Optional)

List of targeted installs to run on hosts. If no targets are specified, infrastructure and logs will be installed by default. Available options are listed in [defaults/main.yml](https://github.com/newrelic/ansible-install/blob/main/defaults/main.yml)

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
- `targets`

## Versions Compatibility

- Ansible: Tested with the Ansible Core 2.13 and 2.14. Ansible Core versions before 2.10 are not supported.
- Python: Tested with Python 3.10.

## Dependencies

Python requirements: [requirements.txt](https://github.com/newrelic/ansible-install/blob/main/requirements.txt)

Ansible requirements: [requirements.yml](https://github.com/newrelic/ansible-install/blob/main/requirements.yml)

## Example Playbook

```
- name: Install New Relic infrastructure and logs
  hosts: all
  roles:
    - role: newrelic.newrelic_install
      vars:
        targets:
          - infrastructure
          - logs
        tags:
          foo: bar
        install_timeout_seconds: 1000
        verbosity: debug
  environment:
    NEW_RELIC_API_KEY: <New Relic User key>
    NEW_RELIC_ACCOUNT_ID: <Account ID>
    NEW_RELIC_REGION: <Region> ('US' or 'EU')
    HTTPS_PROXY: http://my.proxy:8888
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
- [New Relic Community](https://discuss.newrelic.com): The best place to engage in troubleshooting questions
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

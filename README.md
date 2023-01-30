[![Community header](https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png)](https://opensource.newrelic.com/oss-category/#community-project)

[![New Relic Experimental header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Experimental.png)](https://opensource.newrelic.com/oss-category/#new-relic-experimental)

# newrelic.newrelic_install Ansible Role

`newrelic.newrelic_install` is an [Ansible Role](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html) that will help you scale your New Relic observability efforts. It is currently in an experimental phase.

Through this ansible role, we have included Linux and Windows support for New Relic's `infrastructure` and `logs` integrations.

Please, check out the sections below for details on installation, how to get started, role's variables, dependencies and some ansible `playbook` examples showcasing this role's usage.

If you need help with Ansible for Windows OS, take a look at [Setting up a Windows Host](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html), from the [Ansible Documentation](https://docs.ansible.com/ansible/latest/) site.

## Installation

### Ansible Galaxy

`ansible-galaxy install newrelic.newrelic_install`

[Link to Galaxy](https://galaxy.ansible.com/newrelic/newrelic_install)

### Manual

Run `make` in the project root to copy this repo to `~/.ansible/roles/newrelic.newrelic_install`, enabling the role to behave as though it were installed from Galaxy.

## Getting Started

After installing, include the `newrelic.newrelic_install` role in a new or existing playbook. For example:

```
- name: Install New Relic infrastructure & logs
  hosts: all
  roles:
    - role: newrelic.newrelic_install
```

Ensure that the following environment variables are set in your terminal before running the playbook:

- `NEW_RELIC_API_KEY`
- `NEW_RELIC_ACCOUNT_ID`
- `NEW_RELIC_REGION`

## Variables

### Environment Variables

Values are read from environment in [vars/main.yml](https://github.com/newrelic/ansible-install/blob/main/vars/main.yml)

- `NEW_RELIC_API_KEY`
- `NEW_RELIC_ACCOUNT_ID`
- `NEW_RELIC_REGION`

An optional `HTTPS_PROXY` variable can be set to enable a proxy for your installation. Add it to the `environment` keyword in your `playbook`.

You can also optionally override your terminal's environment variables by adding `play` or `role` level variables inside your `environment` keyword in your playbook. See our [Example Playbooks](#example-playbooks) below and [ansible's remote environment](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_environment.html) for more info.

### Role Variables

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

## Dependencies

Python requirements: [requirements.txt](https://github.com/newrelic/ansible-install/blob/main/requirements.txt)

Ansible requirements: [requirements.yml](https://github.com/newrelic/ansible-install/blob/main/requirements.yml)

## Example Playbooks

### Playbook Based on Environment Variables

The following environment variables need to be set on the controller:

- `NEW_RELIC_API_KEY`: <API_KEY>
- `NEW_RELIC_ACCOUNT_ID`: <ACCOUNT_ID>
- `NEW_RELIC_REGION`: <REGION> ("US" or "EU")

Once that is complete, your playbook may just look similar to this example:

```
- name: Install New Relic infrastructure & logs
  hosts: all
  roles:
    - role: newrelic.newrelic_install
      vars:
        targets:
          - infrastructure
          - logs
        tags:
          environment: production
        install_timeout_seconds: 1000
        verbosity: debug
  environment:
    HTTPS_PROXY: http://my.proxy:8888

```

### Playbook with Environment Variables Override

As mentioned [above](#environment-variables), you can use the `environment` keyword in your playbook to override your terminal's environment variables. Note these 2 example playbook options for each case, respectively:

#### Option 1: Play-level Environment Override

```
- name: Install New Relic infrastructure & logs
  hosts: all
  roles:
    - role: newrelic.newrelic_install
  environment:
    NEW_RELIC_ACCOUNT_ID: <ACCOUNT_ID>
    NEW_RELIC_API_KEY: <API_KEY>
    NEW_RELIC_REGION: <REGION> ("US" or "EU")
```

#### Option 2: Role-level Environment Override

```
- name: Install New Relic infrastructure & logs
  hosts: all
  roles:
    - role: newrelic.newrelic_install
      environment:
        NEW_RELIC_ACCOUNT_ID: <ACCOUNT_ID>
        NEW_RELIC_API_KEY: <API_KEY>
        NEW_RELIC_REGION: <REGION> ("US" or "EU")
```

## Support

New Relic hosts and moderates an online forum where customers can interact with
New Relic employees as well as other customers to get help and share best
practices. Like all official New Relic open source projects, there's a related
Community topic in the New Relic Explorers Hub. You can find this project's
topic/threads here:

- [New Relic Documentation](https://docs.newrelic.com): Comprehensive guidance for using our platform
- [New Relic Community](https://discuss.newrelic.com/c/support-products-agents/new-relic-infrastructure): The best place to engage in troubleshooting questions
- [New Relic Developer](https://developer.newrelic.com/): Resources for building a custom observability applications
- [New Relic University](https://learn.newrelic.com/): A range of online training for New Relic users of every level
- [New Relic Technical Support](https://support.newrelic.com/) 24/7/365 ticketed support. Read more about our [Technical Support Offerings](https://docs.newrelic.com/docs/licenses/license-information/general-usage-licenses/support-plan).

## Contribute

We encourage your contributions to improve the `newrelic.newrelic_install` ansible role! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](https://docs.newrelic.com/docs/licenses/license-information/referenced-policies/security-policy/), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

If you would like to contribute to this project, review [these guidelines](https://github.com/newrelic/ansible-install/blob/main/CONTRIBUTING.md).

To all contributors, we thank you! Without your contribution, this project would not be what it is today.

## License

This project is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.

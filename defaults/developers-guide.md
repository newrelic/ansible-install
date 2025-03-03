# Adding a new target support to `ansible-install`

This guide is for developers who want to add support for a new target to the `ansible-install`. 

**Note: The `newrelic_install` role utilizes the New Relic CLI to perform target installations included in Ansible playbooks. All targets in this role depend on the New Relic CLI for installation.**

### Step 1: Update `defaults/main.yml`
- To add a new target, first update the `target_name_map` in `defaults/main.yml`. This map associates each target with its corresponding agent installer. 
- The installer names can be found in the recipes of the [open-install-library](https://github.com/newrelic/open-install-library) repository.

  **Example: Adding Support for a Python Agent:**
  - First, retrieve the agent installer name from the [python](https://github.com/newrelic/open-install-library/blob/main/recipes/newrelic/apm/python/linux.yml) recipe. 
    All agent recipes can be found in `recipes/newrelic` directory.
    The `name` attribute at the top of the .yml file (e.g., `linux.yml`) corresponds to the agent installer name needed for the `target_name_map`.
    
    ![image](https://github.com/user-attachments/assets/050ed2c3-a594-47ea-b023-1a0bd34bf28b)

  - After retrieving the installer name, add it to the `target_name_map` in `defaults/main.yml`.
    From the previous example, updated `target_name_map` for the python agent will look like this:
    
    ![image](https://github.com/user-attachments/assets/30b509c7-b321-4a9e-a46c-d5bf6ab2b38e)

# Testing the New Target

### Step 1: Configure Host File
Update the `tests/inventory` file with the IP address of the target host including SSH configuration for the host.

![image](https://github.com/user-attachments/assets/ad122bd9-2924-4837-b7f8-c8fc78334094)

### Step 3: Create `playbook.yml`
Use the [Playbook Template](https://github.com/newrelic/ansible-install/tree/main?tab=readme-ov-file#example-playbook) as a reference to create a new `playbook.yml`. 
Add the target key to the targets attribute (include any environment variables required by the agent). 

For more information on enviroment variables, please refer to [newrelic docs](https://docs.newrelic.com/).
(For Python example, referred [this](https://docs.newrelic.com/docs/apm/agents/python-agent/configuration/python-agent-configuration/#environment-variables) documentation for required environment variables).

![image](https://github.com/user-attachments/assets/795c80dc-6ccd-4f94-8174-92cda0c0a02f)

**Run the Playbook**: Execute your Ansible playbook with the new target included using the following command:

`ansible-playbook -i ./tests/inventory playbook.yml`






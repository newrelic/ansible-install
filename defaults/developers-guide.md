# Adding a new target support to `newrelic_install` ansible role

This guide is for developers who want to add support for a new target in the `newrelic_install` ansible role. 

**Note: The `newrelic_install` role utilizes the New Relic CLI to perform target installations included in Ansible playbooks. All targets in this role depend on the New Relic CLI for installation.**

### Prerequisites:
- Ensure that Ansible is installed on the system.
- Clone this repository.
- Follow the instructions in this guide, The steps mentioned will only modify the local copy of the `newrelic_install` ansible role. To make these changes live, you will need to:
    - Create a pull request (PR) with your modifications.
    - Once the PR is merged, the changes will be released.
    - After the changes are merged and released, the `newrelic_install` ansible role will be updated on Ansible Galaxy.

### Step 1: Update `defaults/main.yml`
- To add a new target, first update the `target_name_map` in `defaults/main.yml`. This map associates each target with its corresponding agent installer. 
- The installer names can be found in the recipes of the [open-install-library](https://github.com/newrelic/open-install-library) repository.

  **Example: Adding Support for Java Agent:**
  - First, retrieve the agent installer name from the [Java](https://github.com/newrelic/open-install-library/blob/main/recipes/newrelic/apm/java/linux.yml) recipe.
    All agent recipes can be found in `recipes/newrelic` directory.
    The `name` attribute at the top of the .yml file (e.g., `linux.yml`) corresponds to the agent installer name needed for the `target_name_map`.
    
    ![image](https://github.com/user-attachments/assets/3ecde340-d674-42c2-a297-e238a9c60d68)

  - After retrieving the installer name, add it to the `target_name_map` in `defaults/main.yml`.
    From the previous example, updated `target_name_map` for the Java agent will look like this:
    
    ![image](https://github.com/user-attachments/assets/483cef70-0c29-48d2-80f9-47e864b22844)


# Testing the target locally

### Note: 
- To test the **local version** of `newrelic_install` ansible role, first run the `make` command in the root folder of `newrelic_install` ansible role repository.
- To test the **latest version** of `newrelic_install` ansible role, first install the `newrelic_install` ansible role from ansible galaxy using the command  `ansible-galaxy install newrelic.newrelic_install`.

### Step 1: Configure Host File
- Create a hosts file in your ansible testing directory (Using `test-ansible-target` as an example ansible testing directory name).
- Update the `test-ansible-target/hosts` file with the IP address of the target host including SSH configuration for the host.

![image](https://github.com/user-attachments/assets/8b5a8802-d8ba-4eb6-817d-f3536bbc2182)

### Step 2: Create `playbook.yml`
- Use the [Playbook Template](https://github.com/newrelic/ansible-install/tree/main?tab=readme-ov-file#example-playbook) as a reference to create a new `test-ansible-target/playbook.yml`. 
- Add the target key to the targets attribute (include any environment variables required by the agent). For more information on enviroment variables, please refer to [newrelic docs](https://docs.newrelic.com/).
  ![image](https://github.com/user-attachments/assets/b9f24da3-e312-4f92-a742-22b6296f2c4f)
- List of existing targets can be found [here](https://github.com/newrelic/ansible-install?tab=readme-ov-file#targets-required).
  (Note: If you have added a new target support and want to test locally added target then, navigate to `defaults/main.yml` in the root folder of `newrelic_install` ansible role and get the key associated to the corresponding installer in `target_name_map` attribute.)

**Run the Playbook**: Execute your Ansible playbook with the new target included using the following command:

`ansible-playbook -i ./tests/inventory playbook.yml`

**Note: If you are a developer who want to add support for a new target in the `newrelic_install` ansible role, the instructions in this guide for adding a new target support will only modify the local copy of the `newrelic_install` ansible role.**

**To make these changes live, you will need to:**
- **Create a pull request (PR) with your modifications.**
- **Once the PR is merged, the changes will be released.**
- **After the changes are merged and released, the `newrelic_install` ansible role will be updated on Ansible Galaxy.**






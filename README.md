# Playbook Ansible

This project serves as a template for creating Ansible playbooks following automation best practices. It integrates with [Molecule](https://molecule.readthedocs.io/en/latest/) to support Infrastructure as Code (IaC) testing.

## Purpose

This template simplifies the creation and management of automation environments using Ansible, enabling local test environments via Molecule. It is also designed for integration with CI/CD pipelines to ensure automation consistency and quality.

## Prerequisites

Ensure that the following tools are installed on your machine:

- [Python 3](https://www.python.org/downloads/)
- [Ansible](https://docs.ansible.com/)
- [Molecule](https://molecule.readthedocs.io/en/latest/installation.html)
- [Docker](https://www.docker.com/) (for running Molecule tests)

### Dependency Installation

1. **Install Ansible**:

   ```bash
   sudo apt update && sudo apt install ansible unzip git -y
   ```

2. **Set up a Python virtual environment** to isolate dependencies:

   ```bash
   sudo apt install python3-venv
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Install project dependencies**:

   ```bash
   sudo apt install python3-pip
   python3 -m pip install -r requirements.txt
   ```

## Project Structure

The project is structured as follows:

- **`roles/`**: Contains reusable Ansible roles.
- **`molecule/`**: Configuration for Molecule testing scenarios.
- **`tasks/`**: Main tasks executed by the playbooks.
- **`handlers/`**: Handlers for restarting services or performing other actions.
- **`templates/`**: Jinja2 templates for configuration files.
- **`files/`**: Static files deployed to target hosts.
- **`tests/`**: Integration tests and inventory for testing environments.

## Usage

### Running Locally (Without Inventory)

The project is configured to run on `localhost` by default, allowing you to apply playbooks directly to your local machine.

To execute the playbook on your local machine:

```bash
ansible-playbook -i tests/inventory playbook.yml --connection=local --ask-become-pass
```

This runs the playbook on your local machine, using Ansible's `localhost` connection.

### Running Local Tests with Molecule

Molecule allows you to test Ansible playbooks in Docker containers, simulating production environments.

1. **Create a test environment**:

   ```bash
   molecule create
   ```

2. **Run the playbook** in the test environment:

   ```bash
   molecule converge
   ```

3. **Verify the result** of the playbook execution:

   ```bash
   molecule verify
   ```

4. **Destroy the test environment** after use:

   ```bash
   molecule destroy
   ```

5. **Run all tests in one command**:

   ```bash
   molecule test
   ```

### Optional Inventory Structure

If you prefer to run the playbook on a set of remote hosts, you can define an inventory file as follows:

```ini
[webservers]
192.168.0.101
192.168.0.102
```

However, for local execution, this is not required.

## Variables

Global variables are stored in `group_vars` or can be directly set in the playbook. These allow customization of package installation and configuration.

Example of common variables:

```yaml
ansible_user_id: "{{ lookup('env', 'USER') }}"
common_packages:
  - vim
  - curl
  - wget
  - git
  - zsh
```

## Handlers

The project includes handlers that restart services like Docker and rsyslog to ensure configurations are correctly applied.

Example handler:

```yaml
- name: Restart Docker
  ansible.builtin.service:
    name: docker
    state: restarted
```

## Customization

Feel free to modify the project to suit your needs. You can add new roles, adjust tasks, or change templates to automate additional services and workflows.

## Debugging Tips

1. **Verbose Mode**: To run Ansible with detailed logging, use the `-vvv` flag:

   ```bash
   ansible-playbook playbook.yml -vvv
   ```

2. **Test in a controlled environment**: Use Molecule to test playbooks in a simulated environment before applying them in production.

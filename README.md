# Template Role Ansible

Este projeto serve como um template para criação de playbooks Ansible utilizando boas práticas de automação, além de fornecer integração com [Molecule](https://molecule.readthedocs.io/en/latest/) para testes de infraestrutura como código.

## Objetivo

Este template facilita a criação e gestão de ambientes de automação com Ansible, permitindo o uso de um ambiente de testes local baseado no Molecule. Também pode ser utilizado em pipelines de CI/CD para garantir a consistência e qualidade da sua automação.

## Dependências

Antes de começar, é necessário ter as seguintes ferramentas instaladas na sua máquina:

- [Python 3](https://www.python.org/downloads/)
- [Ansible](https://docs.ansible.com/)
- [Molecule](https://molecule.readthedocs.io/en/latest/installation.html)
- [Docker](https://www.docker.com/) (para testar os playbooks com Molecule)

### Instalação de Dependências

1. **Instale o Ansible**:

   ```bash
   sudo apt update && sudo apt install ansible unzip git -y
   ```

2. **Criar um ambiente Python virtual** para isolamento:

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Instalar as dependências do projeto**:

   ```bash
   sudo apt install python3-pip
   python3 -m pip install -r requirements.txt
   ```

## Estrutura do Projeto

O projeto é organizado da seguinte maneira:

- `roles/`: contém as funções Ansible reutilizáveis.
- `molecule/`: configuração dos cenários de teste Molecule.
- `tasks/`: tarefas principais que serão executadas.
- `handlers/`: gerencia reinicializações e serviços.
- `templates/`: templates usados para arquivos de configuração.
- `files/`: arquivos que são enviados para os hosts de destino.

## Como Usar

### Execução Local no Host (sem inventário)

Este projeto já está configurado para ser executado em `localhost`, o que significa que você pode rodar os playbooks diretamente na máquina local, sem a necessidade de alterar o inventário.

Para executar o playbook diretamente no host local:

```bash
ansible-playbook playbook.yml
```

Isso aplicará o playbook na máquina local usando o Ansible com `localhost` como alvo por padrão.

### Testes Locais com Molecule

O Molecule permite testar a execução dos playbooks Ansible localmente usando containers Docker, simulando um ambiente de produção.

1. **Criar o ambiente de teste**:

   ```bash
   molecule create
   ```

2. **Executar o playbook** no ambiente de teste:

   ```bash
   molecule converge
   ```

3. **Verificar o resultado** dos testes:

   ```bash
   molecule verify
   ```

4. **Destruir o ambiente de teste** após a execução:

   ```bash
   molecule destroy
   ```

5. **Executar todos os testes de uma vez**:

   ```bash
   molecule test
   ```

### Estrutura do Inventário (Opcional)

Se desejar personalizar o inventário ou rodar o playbook em um conjunto específico de máquinas, você pode definir um inventário opcionalmente, criando um arquivo `hosts` como abaixo:

```ini
[webservers]
192.168.0.101
192.168.0.102
```

Mas se sua intenção for rodar o playbook na máquina local, isso não é necessário.

## Variáveis

As variáveis globais usadas no projeto estão armazenadas no diretório `group_vars` ou podem ser definidas diretamente no playbook. Elas permitem a personalização da instalação e configuração de pacotes.

Exemplo de variáveis:

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

O projeto inclui handlers para reiniciar serviços como Docker e rsyslog. Isso é útil para garantir que as configurações sejam aplicadas corretamente. 

Por exemplo:

```yaml
- name: Restart Docker
  ansible.builtin.service:
    name: docker
    state: restarted
```

## Personalização

Você pode ajustar os arquivos do projeto conforme suas necessidades. Os templates e arquivos de configuração podem ser facilmente modificados para incluir outros serviços e pacotes.

## Dicas de Debug

1. **Execução verbose**: Para executar o Ansible com mais detalhes, use a flag `-vvv`:

   ```bash
   ansible-playbook playbook.yml -vvv
   ```

2. **Testar em ambiente controlado**: Antes de aplicar em produção, execute o playbook em um ambiente de staging ou local usando Molecule.
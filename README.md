
```
Deploy a Kubernetes HA (multi-masters) Cluster using Terraform/Ansible on Alma Linux/Rocky OS - (Hetzner)
```

```
First we need to obtain a API token from our Hetzner account.
Project >> Security >> API token >> Generate API token
```

```
SSH_KEY config:
update user_data.yml and ssh.tf with correct info.
```

```
variable config:
update variable.tf with correct info.
```

```
install Python or skip if it's already present on your local machine
{
    sudo yum -y groupinstall "Development Tools"
    sudo yum -y install openssl-devel bzip2-devel libffi-devel xz-devel wget
    cd /usr/src/ 
    sudo wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
    sudo tar -xvzf Python-3.8.12.tgz
    cd Python-3.8.12/
    ./configure --enable-optimizations
    sudo make altinstall
    python3.8 --version
}
```

```
install Ansible or skip if it's already present on your local machine
{
    cd
    python3.8 -m venv project
    source project/bin/activate
    pip install --upgrade pip
    pip install ansible
}
```

```
install required collections for ansible:
{
    ansible-galaxy collection install ansible.posix
    ansible-galaxy collection install kubernetes.core
}
```

```
Run the following commmands: (it will prompt you for API_TOKEN)
terraform init
terraform plan
terraform apply
```
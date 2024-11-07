
### Deploy a Kubernetes HA (multi-masters) Cluster using Terraform/Ansible on Ubuntu - (Hetzner)

#### First we need to obtain a API token from our Hetzner account.

`Project >> Security >> API token >> Generate API token`

##### Updating SSH KEY info
`user_data.yml`

`ssh.tf`

##### Updating Variables
'variable.tf'

###### important ones are:
`location`

`server_type`

`kubernetes_package_version`

`kubernetes_version`

`k8s_repo_version`

`eth_name`

#### Installing Python
```
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

#### Installing Ansible
```
{
    cd
    python3.8 -m venv project
    source project/bin/activate
    pip install --upgrade pip
    pip install ansible
}
```

#### Installing Ansible Collection
```
{
    ansible-galaxy collection install ansible.posix
    ansible-galaxy collection install kubernetes.core
}
```

#### Running Terraform
(it will prompt you for API_TOKEN)
```
terraform init
terraform plan
terraform apply
```

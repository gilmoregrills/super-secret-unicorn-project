# super-secret-unicorn-project

## Build steps:

### Terraform:

Note: Make sure you edit the `params.tfvars` file to add the name of a pem key to use for ssh access

`cd terraform`

`./build-backend.sh <project-name> <region>`
Example:
`./build-backend.sh super-secret-unicorn-project eu-west-1`

`terraform init -backend-config=<project-name>-backend`
`terraform init -backend-config=super-secret-unicorn-project-backend`

`terraform apply -var-file=params.tfvars`

`cd ..`

### Ansible:

Once instances come up, add IPs to `hosts` file, test the connection with:

`ansible py3-webserver -m ping -i hosts`

Run ansible playbook to install docker, build the image and run it on the server(s)

`ansible-playbook -i hosts playbook.yml`

### Test with Docker locally:

`docker build -t unicorn-service .`

`docker run -p 80:8080 unicorn-service`

TODOs:
* find way to dynamically fetch all the instances and apply the config to them
* automate with a main build script?
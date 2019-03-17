# super-secret-unicorn-project

If it helps, it might actually be running at: ec2-34-240-61-22.eu-west-1.compute.amazonaws.com still

## Build steps:

### Terraform:

Note: Make sure you edit the `params.tfvars` file to add the name of a pem key to use for ssh access

`cd terraform`

`./build-backend.sh <project-name> <region>`
Example:
`./build-backend.sh super-secret-unicorn-project eu-west-1`

`terraform init -backend-config=<project-name>-backend`
Example:
`terraform init -backend-config=super-secret-unicorn-project-backend`

`terraform apply -var-file=params.tfvars`

`cd ..`

### Ansible:

Once instances come up, add IPs to `hosts` file, test the connection with:

`ansible py3-webserver -m ping -i hosts`

Run ansible playbook to install docker, build the image and run it on the server(s)

`ansible-playbook -i hosts playbook.yml`

### If you wanna test with Docker locally:

`docker build -t unicorn-service .`

`docker run -p 80:8080 unicorn-service`

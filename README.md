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

### Docker:

`docker build -t unicorn-service .`

`docker run unicorn-service -p 80:8080 --name unicorn-server`
#!/bin/bash
###
#   example ./build_backend.sh name eu-west-1
###

# Note: I stole a chunk of this script from another project, I just used it to
# build my remote backend so I thought I'd best include it

set -ie

project_name=${1}
region=${3}

if [ -z "${project_name}" ];
then
  echo "Project name not provided";
  exit 1;
fi

# if region not set, default to ireland region
if [ -z "${region}" ];
then
  region=eu-west-1
fi

# Create bucket
aws s3api create-bucket --bucket ${project_name}-tf-state --region ${region} --create-bucket-configuration LocationConstraint=${region}

echo "Bucket created named: ${project_name}"

if [ -e ${project_name}-backend ]
then
  echo "File exists. Modify existing backend configuration for project_name: ${project_name}";
  exit 1;
else
  echo "File doesn't exist. Creating new backend configuration...";

  sed "s|@STATE_BUCKET_NAME@|${project_name}-tf-state|g" \
    backend-template > ${project_name}-backend
fi

echo "New backend config file: ${project_name}-backend use it to initilise terraform backend. See README.md"

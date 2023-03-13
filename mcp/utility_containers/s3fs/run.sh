#!/bin/bash

mkdir -p /mnt/s3fs/
instance_profile_id=$(curl http://169.254.169.254/latest/meta-data/iam/info | jq -r '.InstanceProfileId')
instance_role=$(aws iam list-instance-profiles --query "InstanceProfiles[?InstanceProfileId=='$instance_profile_id'].Roles" | jq -r '.[0][0].RoleName')

echo "s3fs ${bucket_name}:/nfs/${application} /mnt/s3fs/ -o iam_role=$instance_role -o use_cache=/tmp"
s3fs ${bucket_name}:/nfs/${application} /mnt/s3fs/ -o iam_role=$instance_role -o use_cache=/tmp -o uid=1000,gid=1000,allow_other,mp_umask=002

tail -f /dev/null
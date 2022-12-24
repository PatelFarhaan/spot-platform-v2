#!/bin/bash

s3_bucket="s3://biosmesh-spot-plane/worker_agents/"
echo "Deploying files to: ${s3_bucket}..."
echo ""
cd ./s3 &&
aws s3 cp ./ ${s3_bucket} --recursive

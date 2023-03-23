AWS_PROFILE := bios
AWS_REGION := us-east-1

export AWS_REGION
export AWS_PROFILE

#<==================================================================================================>
#                                            TELEMETRY
#<==================================================================================================>

# PUBLISH DOCKER COMPOSE FILES TO S3
.PHONY: publish_telemetry_docker_files
publish_telemetry_docker_files:
	cd observability && \
	aws s3 rm s3://biosmesh-spot-plane/observability/docker_agents --recursive && \
	aws s3 cp docker_agents s3://biosmesh-spot-plane/observability/docker_agents --recursive


# TERRAFORM PLAN
.PHONY: plan_telemetry
plan_telemetry:
	cd observability && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform plan
	


# TERRAFORM APPLY
.PHONY: deploy_telemetry
deploy_telemetry:
	cd observability && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform apply
	


# TERRAFORM DESTROY
.PHONY: teardown_telemetry
teardown_telemetry:
	cd observability && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform destroy
	


#<==================================================================================================>
#                                            DEPLOYMENTS
#<==================================================================================================>

# PUBLISH DOCKER COMPOSE FILES TO S3
.PHONY: publish_deployment_docker_files
publish_deployment_docker_files:
	cd deployment && \
	aws s3 rm s3://biosmesh-spot-plane/deployment/docker_agents --recursive && \
	aws s3 cp docker_agents s3://biosmesh-spot-plane/deployment/docker_agents --recursive


# TERRAFORM PLAN
.PHONY: plan_deployment
plan_deployment:
	cd deployment && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform plan
	


# TERRAFORM APPLY
.PHONY: deploy_deployment
deploy_deployment:
	cd deployment && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform apply
	


# TERRAFORM DESTROY
.PHONY: teardown_deployment
teardown_deployment:
	cd deployment && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform destroy
	


#<==================================================================================================>
#                                            SIDECAR CONTAINERS
#<==================================================================================================>

# HOST SIDECAR
.PHONY: build_and_deploy_hostsidecar
build_and_deploy_hostsidecar:
	cd worker_nodes && \
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ***REMOVED***.dkr.ecr.us-east-1.amazonaws.com && \
	docker buildx build --push --platform linux/arm64,linux/x86_64 -t ***REMOVED***.dkr.ecr.us-east-1.amazonaws.com/biosmesh-internal-apps:host-sidecar .


# CRONJOBS SIDECAR
.PHONY: build_and_deploy_cronjobs
build_and_deploy_cronjobs:
	cd sidecar_containers/cron_jobs && \
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ***REMOVED***.dkr.ecr.us-east-1.amazonaws.com && \
	docker buildx build --push --no-cache --platform linux/arm64,linux/x86_64 -t ***REMOVED***.dkr.ecr.us-east-1.amazonaws.com/biosmesh-internal-apps:cronjobs .

#<==================================================================================================>
#                                            VARIABLES
#<==================================================================================================>
AWS_PROFILE := bios
AWS_REGION := us-east-1
ECR_HOST := ***REMOVED***.dkr.ecr.us-east-1.amazonaws.com

export AWS_REGION
export AWS_PROFILE


#<==================================================================================================>
#                                            FUNCTIONS
#<==================================================================================================>
# TERRAFORM FUNCTIONS
define terraform_functions
	cd "$(2)" && \
  	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json

	if [ "$(1)" = "plan" ] ; then \
		cd "$(2)/tf" && terraform plan; \
	elif [ "$(1)" = "deploy" ] ; then \
		cd "$(2)/tf" && terraform apply; \
	elif [ "$(1)" = "teardown" ] ; then \
		cd "$(2)/tf" && terraform destroy; \
	elif [ "$(1)" = "refresh" ] ; then \
		cd "$(2)/tf" && terraform refresh; \
	fi
endef

# UPLOAD PLATFORM FILES TO S3
define upload_to_s3
	cd "$(1)" && \
	aws s3 rm "s3://biosmesh-spot-plane/$(1)/docker_agents" --recursive && \
	aws s3 cp docker_agents "s3://biosmesh-spot-plane/$(1)/docker_agents" --recursive
endef

# ECR LOGIN
ecr_login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_HOST)


#<==================================================================================================>
#                                            LANDSCAPE
#<==================================================================================================>

# TERRAFORM PLAN
plan_landscape:
	cd landscape && \
	cd ./tf && terraform plan

# TERRAFORM APPLY
deploy_landscape:
	cd landscape && \
	cd ./tf && terraform apply


#<==================================================================================================>
#                                            TELEMETRY
#<==================================================================================================>

# PUBLISH DOCKER COMPOSE FILES TO S3
publish_telemetry_docker_files:
	$(call upload_to_s3,observability)

# TERRAFORM PLAN
plan_telemetry:
	$(call terraform_functions,plan,observability)

# TERRAFORM REFRESH
refresh_telemetry:
	$(call terraform_functions,refresh,observability)

# TERRAFORM APPLY
deploy_telemetry:
	$(call terraform_functions,deploy,observability)

# TERRAFORM DESTROY
teardown_telemetry:
	$(call terraform_functions,teardown,observability)


#<==================================================================================================>
#                                            DEPLOYMENTS
#<==================================================================================================>

# PUBLISH DOCKER COMPOSE FILES TO S3
publish_deployment_docker_files:
	$(call upload_to_s3,deployment)

# TERRAFORM PLAN
plan_deployment:
	$(call terraform_functions,plan,deployment)

# TERRAFORM REFRESH
refresh_deployment:
	$(call terraform_functions,refresh,deployment)

# TERRAFORM APPLY
deploy_deployment:
	$(call terraform_functions,deploy,deployment)

# TERRAFORM DESTROY
teardown_deployment:
	$(call terraform_functions,teardown,deployment)


#<==================================================================================================>
#                                            SIDECAR CONTAINERS
#<==================================================================================================>

# HOST SIDECAR
build_and_deploy_hostsidecar: ecr_login
	cd worker_nodes && \
	docker buildx build --push --platform linux/arm64,linux/x86_64 -t $(ECR_HOST)/biosmesh-internal-apps:host-sidecar .


# CRONJOB SIDECAR
.PHONY: build_and_deploy_cronjobs
build_and_deploy_cronjobs: ecr_login
	cd sidecar_containers/cron_jobs && \
	docker buildx build --push --platform linux/arm64,linux/x86_64 -t $(ECR_HOST)/biosmesh-internal-apps:cronjobs .

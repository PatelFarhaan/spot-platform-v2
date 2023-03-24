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

	if [ "$(1)" = "init" ] ; then \
		cd "$(2)/tf" && terraform init; \
	elif [ "$(1)" = "plan" ] ; then \
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
landscape_plan:
	cd landscape && \
	cd ./tf && terraform plan

# TERRAFORM APPLY
landscape_deploy:
	cd landscape && \
	cd ./tf && terraform apply


#<==================================================================================================>
#                                            TELEMETRY
#<==================================================================================================>

# PUBLISH DOCKER COMPOSE FILES TO S3
telemetry_publish_docker_files:
	$(call upload_to_s3,observability)

# TERRAFORM INIT
telemetry_init:
	$(call terraform_functions,init,observability)

# TERRAFORM PLAN
telemetry_plan:
	$(call terraform_functions,plan,observability)

# TERRAFORM REFRESH
telemetry_refresh:
	$(call terraform_functions,refresh,observability)

# TERRAFORM APPLY
telemetry_deploy:
	$(call terraform_functions,deploy,observability)

# TERRAFORM DESTROY
telemetry_teardown:
	$(call terraform_functions,teardown,observability)


#<==================================================================================================>
#                                            DEPLOYMENT
#<==================================================================================================>

# PUBLISH DOCKER COMPOSE FILES TO S3
deployment_publish_docker_files:
	$(call upload_to_s3,deployment)

# TERRAFORM INIT
deployment_init:
	$(call terraform_functions,init,observability)

# TERRAFORM PLAN
deployment_plan:
	$(call terraform_functions,plan,deployment)

# TERRAFORM REFRESH
deployment_refresh:
	$(call terraform_functions,refresh,deployment)

# TERRAFORM APPLY
deployment_deploy:
	$(call terraform_functions,deploy,deployment)

# TERRAFORM DESTROY
deployment_teardown:
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

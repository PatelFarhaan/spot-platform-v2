.PHONY: build_and_deploy_hostsidecar
build_and_deploy_hostsidecar:
	cd worker_nodes && \
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 774723060820.dkr.ecr.us-east-1.amazonaws.com && \
	docker buildx build --push --platform linux/arm64,linux/x86_64 -t 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-mcp:host-sidecar .


.PHONY: build_and_deploy_cronjobs
build_and_deploy_cronjobs:
	cd worker_nodes/custom_images/cron_jobs && \
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 774723060820.dkr.ecr.us-east-1.amazonaws.com && \
	docker buildx build --push --no-cache --platform linux/arm64,linux/x86_64 -t 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-mcp:cronjobs .


.PHONY: plan_deployment
plan_deployment:
	cd deployment && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform plan && \
	cd ./../ && rm -rf ./cluster_config.yml


.PHONY: deploy_deployment
deploy_deployment:
	cd deployment && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform apply
	cd ./../ && rm -rf ./cluster_config.yml


.PHONY: teardown_deployment
teardown_deployment:
	cd deployment && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform destroy && \
	cd ./../ && rm -rf ./cluster_config.yml


.PHONY: plan_observability
plan_observability:
	cd observability && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform plan
	cd ./../ && rm -rf ./cluster_config.yml


.PHONY: deploy_observability
deploy_observability:
	cd observability && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform apply && \
	cd ./../ && rm -rf ./cluster_config.yml


.PHONY: teardown_observability
teardown_observability:
	cd observability && \
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform destroy && \
	cd ./../ && rm -rf ./cluster_config.yml

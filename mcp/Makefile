.PHONY: build_worker
build_worker:
	cd worker_nodes
	docker buildx build --platform linux/arm64 --no-cache -t 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-mcp:host-sidecar-arm64 .
	docker buildx build --platform linux/x86_64 --no-cache -t 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-mcp:host-sidecar-x86_64 .


.PHONY: deploy_worker
deploy_worker:
	cd worker_nodes
	export AWS_PROFILE=bios && export AWS_REGION=us-east-1
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 774723060820.dkr.ecr.us-east-1.amazonaws.com
	docker push 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-mcp:host-sidecar-arm64
	docker push 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-mcp:host-sidecar-x86_64


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
	cd ./tf && terraform apply && \
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
	cd ./tf && terraform plan && \
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


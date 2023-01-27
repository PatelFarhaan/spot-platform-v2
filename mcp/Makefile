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

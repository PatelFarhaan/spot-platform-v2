.PHONY: build
build:
	docker build --no-cache -t 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-all-apps:host-sidecar .


.PHONY: deploy
deploy:
	export AWS_PROFILE=bios && export AWS_REGION=us-east-1
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 774723060820.dkr.ecr.us-east-1.amazonaws.com
	docker push 774723060820.dkr.ecr.us-east-1.amazonaws.com/biosmesh-all-apps:host-sidecar

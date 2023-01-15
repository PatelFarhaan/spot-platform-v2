.PHONY: tf_apply
tf_apply:
	aws s3 cp s3://biosmesh-spot-plane/cluster_config.json ./cluster_config.json && \
	cat ./cluster_config.json | yq . -P > ./cluster_config.yml && \
	rm -rf ./cluster_config.json && \
	cd ./tf && terraform apply && \
	rm -rf ./cluster_config.yml


.PHONY: tf_destroy
tf_destroy:
	cd ./tf && terraform destroy

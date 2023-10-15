#<==================================================================================================>
#                                            VARIABLES
#<==================================================================================================>
AWS_PROFILE := bios
AWS_REGION := us-east-1

export AWS_REGION
export AWS_PROFILE


#<==================================================================================================>
#                                            FUNCTIONS
#<==================================================================================================>
define terraform_functions
	cd "$(2)" && mkdir config && \
	aws s3 cp s3://biosmesh-spot-plane/config/ ./config/ --recursive

	if [ "$(1)" = "init" ] ; then \
		cd "$(2)/tf" && terraform init; \
	elif [ "$(1)" = "plan" ] ; then \
		cd "$(2)/tf" && terraform plan; \
	elif [ "$(1)" = "apply" ] ; then \
		cd "$(2)/tf" && terraform apply; \
	elif [ "$(1)" = "destroy" ] ; then \
		cd "$(2)/tf" && terraform destroy; \
	fi

	rm -rf "$(2)/config"
endef


#<==================================================================================================>
#                                            DEPLOYED APPS
#<==================================================================================================>
backend_plan:
	$(call terraform_functions,plan,backend)

backend_apply:
	$(call terraform_functions,apply,backend)

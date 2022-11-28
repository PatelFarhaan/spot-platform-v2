SHELL := /bin/bash



#.PHONY: create_tf_s3
create_tf_s3:
	region=$(cat ./config.json | jq -r ".region")
	profile=$(cat ./config.json | jq -r ".aws_profile")
	tf_state_bucket_name=$(cat ./config.json | jq -r ".tf_state_bucket_name")

	aws s3api create-bucket \
		--bucket=$tf_state_bucket_name --acl=private --profile=$profile -- region=$region

	aws s3api put-bucket-versioning \
		--bucket=$tf_state_bucket_name --versioning-configuration Status=Enabled

	aws s3api put-public-access-block \
    	-bucket=$tf_state_bucket_name \
    	--public-access-block-configuration \
    	"BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"


#.PHONY: create_tf_dynamodb
create_tf_dynamodb:
	region=$(cat ./config.json | jq -r ".region")
	profile=$(cat ./config.json | jq -r ".aws_profile")
	tf_state_lock_dynamodb=$(cat ./config.json | jq -r ".tf_state_lock_dynamodb")

	aws dynamodb create-table \                                                                                                                                <aws:bios>
        --table-name=tf_state_lock_dynamodb \
        --key-schema AttributeName=LockID,KeyType=HASH \
		--attribute-definitions AttributeName=LockID,AttributeType=S --provisioned-throughput \
				ReadCapacityUnits=5,WriteCapacityUnits=5 \
		--table-class=STANDARD

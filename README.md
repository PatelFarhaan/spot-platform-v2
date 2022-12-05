#### STEPS FOR CREATING A BIOMESH CLUSTER: MONITORING, OBSERVABILITY AND DEPLOYMENT

1. Run `base-tf` folder to create the S3 and DynamoDB resources to store/lock tf state files
2. Run `mcp-deplment` folder to a Jenkins server which contains all application deployment scripts
3. Once the Jenkins server is up and running, then run the `base-ami` pipeline with the respective configuration
to create the ami which contains all the necessary tools to run the containers
4. Once this is completed, then run the `mcp-mo` (mo: monitoring and observability) to create the instance which 
will store all the logs and metrics of the application service
5. Once this is completed, then we are good to create/deploy the application using application service in the Jenkins
server


Todo:
1. Make sure IAM names are region based
2. Make sure R53 names are region based
3. Checkin issue with Instance Profile name
4. Integrate SPOT LC with current TF module
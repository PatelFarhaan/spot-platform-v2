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



Issues:
1. Nginx only routes logs of traffic on port 80



Volume Automation -> Base it on percentage instead of GB: round off to the nearest integer
Make Databases deployment and observability work



Make new VPC's
Deploy everything in a private subnet
Create Jenkins job for creating base AMI
Create Webapp to create Jenkins CICD from api call
Create env and secrets to store in db through api
Make sure CD works
Collect metrics from grafana/prometheus for each app for scaling
Create a custom auto scalar app
Support for cluster turn off and turn on automatically
Having Alerts only on main_application pods

webapp for spot pricing:
    simple 2 to 4 apis
        original cost, spot price, cost difference percentage -> based on cpu, mem and storage

cli: aws ec2 describe-instance-*
cli aws ec2   describe-spot-price-history

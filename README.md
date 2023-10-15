#### STEPS FOR CREATING A BIOMESH CLUSTER: MONITORING, OBSERVABILITY AND DEPLOYMENT

1. Run `base-tf` folder to create the S3 and DynamoDB resources to store/lock tf state files
2. Run `mcp-deplment` folder to a Jenkins server which contains all application deployment scripts
3. Once the Jenkins server is up and running, then run the `base-ami` pipeline with the respective configuration
   to create the ami which contains all the necessary tools to run the containers
4. Once this is completed, then run the `mcp-mo` (mo: monitoring and observability) to create the instance which
   will store all the logs and metrics of the application service
5. Once this is completed, then we are good to create/deploy the application using application service in the Jenkins
   server

There are only 100 rules per LB: if any app is close to that, create a new lb
p99, latancy records
auto instrumentation for traces and metrics using open telemetry
configure aws ssm agents

latest:
convert to yaml -> Done
remove prod tf from client -> Done
update host sidecar to use config.yml and replace deployment.json with config.yml -> Done
http redirect logic in client tf instead of landscape
add sts support
add internal LB
support for config map
https://marcospereirajr.com.br/using-nginx-as-api-gateway-7bebb3614e48
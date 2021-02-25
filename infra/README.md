# IaC with Terraform for NoteJam

A set of Terraform templates used for provisioning web application stacks on [AWS ECS Fargate][fargate].

## Requirements
These elements are required to run terraform scripts.

| Name | Description |
|------|-------------|
| AWS Credentials | Assuming that AWS Access keys have been configured using 'aws configure' command |
| terraform | Terraform executable files has be to configured to run scripts |

Credential information can be updated using [provider.tf][provider] file.

## Terraform scripts

| Name | Description | 
|------|-------------|
| [variables.tf][variables] | All variable declarations and their default values |
| [provider.tf][provider] | Cloud provider and availability zone definitions |
| [network.tf][network] |  Definitions of VPC, Private/Public Subnets and Gateway |
| [security.tf][security] | ALB Security Group, access restrictions to ECS |
| [alb.tf][alb] | Resource definitions for AWS Load Balancer |
| [ecs.tf][ecs] | Container, Task, Service and Cluster definitions |
| [auto_scaling.tf][auto_scaling] | Auto scaling and CloudWatch definitions |
| [logs.tf][logs] | Set up CloudWatch group and log stream |
| [outputs.tf][outputs] | Displaying Load balancer dns_name for the application  |
| [testing.tfvars][testing] | Test Environment definitions |

## Deployment

Clone the ganesh35/notejam github repository.

```sh
git clone https://github.com/ganesh35/notejam.git
cd notejam/infra
```

This will have all the terraform files needed to create the ECS Fargate stack along with other resources like vpc, security groups, load-balancer etc.

Once you have the repository. Initialize the terraform to get required modules and then run terraform plan to see what all resources terraform will create.

```sh
terraform init
terraform plan      
terraform apply -var-file="testing.tfvars"
```

This will create the whole cluster and will give an endpoint of a loadbalancer on which application will be running.
Accessing this endpoint in browser should show the notejam home page which means this deployment is successful.


## Switching / Creating Environments

Create more environments from the attached file [testing.tfvars][testing]
```sh
cp testing.tfvars prodution.tfvars
nano production.tfvars
```

Add changes to production.tfvars and deploy application.
```sh
terraform apply -var-file="production.tfvars"
```

## Destroy 
Do not forget to desctroy deployed stacks when not using.
```sh
terraform destroy
```

[fargate]: https://aws.amazon.com/fargate/
[variables]: ./variables.tf
[provider]: ./provider.tf
[network]: ./network.tf
[security]: ./security.tf
[alb]: ./alb.tf
[ecs]: ./ecs.tf
[auto_scaling]: ./auto_scaling.tf
[logs]: ./logs.tf
[outputs]: ./outputs.tf
[testing]: ./testing.tfvars

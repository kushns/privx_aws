# PrivX on AWS 
This project simplifies PrivX on-boarding experience with deployment automation using Infrastructure as a Code (terraform).


## Description:
This repo contain terraform code to spin 3 EC2 instances, AWS RDS postgreSQL database and AWS ElastiCache redis.

* Postgresql Database : AWS RDS PostgreSQL Database

* Redis Cache  : AWS ElasticCache Redis 

* PrivX Server :  Centos7 AMI used for this instance and PrivX installation and configuration are being done as post build steps.

* PrivX Carrier : Centos7 AMI used for this instance and PrivX Carrier installation is being done as post build steps. Carrier configuration needs to be done manually.  

* PrivX Web Proxy : Centos7 AMI used for this instance and PrivX Web Proxy installation is being done as post build steps. Web Proxy configuration needs to be done manually.


## Pre-requisites : Install/Configure AWS and Terraform and update variables

1. Install [AWS CLI](https://aws.amazon.com/cli/) and use `aws configure` command to configure it.
1. Install [Terraform](https://www.terraform.io/).
1. Please don't forget to update variables in starter.tfvars files.

#### Mandatory Variables need to be updated
```
# AWS region to be used
region = "eu-west-2"

# AWS availability_zone to be used
availability_zone = "eu-west-2a"

# AWS key pair name for SSH password less authentication.
key_name = "default-linux-key"

# Private key path for key name specified above, Update private key path
private_key = "..\\aws\\default-linux-key-openssh.txt"
```

**Note:** private_key and secret.tf.vars files should be created outside git repo as these files contain credentials and private_key.

* To use Static password: Create secret.tfvars file and update password as shown below else RANDOM password will be generated and included in output.
```
database_password = "<mypassword>"
superuser_password = "<mypassword>"
```

## Deployment
1. Run `terraform init`
1. Run `terraform plan -var-file=../secret.tfvars` 
1. If plan looks good, run `terraform apply -var-file=../secret.tfvars`

**Note:** No need to specify "-var-file=../secret.tfvars" if using RANDOM password

In the final step, please obtain a [license code](https://info.ssh.com/privx-free-access-management-software) to activate your environment.

## Configuration steps for PrivX Carrier and PrivX Web Proxy

#### To activate a PrivX license with the online method:
1. Access the PrivX GUI and navigate to the Settings→License page.
2. Under the License code section, enter your license code, and click Update License.

PrivX automatically installs your license, which enables PrivX functionality according to your license subscription.

#### Create a Carrier and Web-Proxy configuration.
1. In the PrivX GUI navigate to Settings→Deployment→Deploy PrivX web-access gateways.
1. To create the configurations, click Add Web-Access Gateway. Provide at least the Name and Proxy Address for the configuration.
1. Download the configurations (required later for setting up Carriers and Web Proxies). To do this, click  next to your configuration, then click Download Carrier Config and Download Proxy Config.

#### Configure PrivX Carrier
1. Copy your Carrier-configuration file to your Carrier machine, to the following path:

   `/opt/privx/etc/carrier-config.toml`
1. To finalize setup and register the Carrier with PrivX, run:

   `/opt/privx/scripts/carrier-postinstall.sh`
   
#### Configure PrivX WebProxy
1. Copy the Web-Proxy configuration file to the machine, to the following location:

   `/opt/privx/etc/web-proxy-config.toml`
1. To finalize setup and register the Web Proxy with PrivX, run:

   ` /opt/privx/scripts/web-proxy-postinstall.sh`
   
## Next Steps
 * [Getting Started with PrivX](https://help.ssh.com/support/solutions/articles/36000194728-getting-started-with-privx)
 * Learn more about [PrivX Users and Permissions](https://help.ssh.com/support/solutions/articles/36000194730-privx-users-and-permissions)
 * Check [Online Administrator Manual](https://help.ssh.com/support/solutions/folders/36000185818)
 

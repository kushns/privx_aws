# AWS region to be used
region = "eu-west-2"

# AWS availability_zone to be used
availability_zone = "eu-west-2a"

# EC2 instance type (all default to t2.medium, uncomment and update if required)
#instance_typedb            = "t2.medium"
#instance_typeprivx         = "t2.medium"
#instance_typeprivxcarrier  = "t2.medium"
#instance_typeprivxwebproxy = "t2.medium"

# AWS key pair name for SSH password less authentication, Update Key name used in your AWS account
#key_name = "default-linux-key"
key_name = "UK-AWS-PSLab"

# Private key path for key name specified above, Update private key path
#private_key = "..\\aws\\default-linux-key-openssh.txt"
private_key = "..\\aws\\UK-AWS-PSLab.txt"

# privx superuser (default to admin, uncomment and update if required)
#privx_superuser = "admin"

# email domain (default to example.com, uncomment and update if required)
#email_domain = "example.com"

# postgresql database name (default to privx, uncomment and update if required)
#database_name = "privx"

# postgresql database user name (default to privx, uncomment and update if required)
#database_username = "privx"

# Database allocated storage (default to 20 GB, uncomment and update if required)
#allocated_storage = 20


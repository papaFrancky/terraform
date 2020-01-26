# 'admin' EC2 instance


## Introduction
The 'admin' EC2 instance is a small EC2 instance with an AdministratorAccess IAM policy attached. It means it has full access over all the services provided by AWS.


## Instance name
Tag Name = \<env\>-admin

DNS name = \<env\>-admin.codeascode.net

*( with \<env\> = [ dev | tst | acc | prod ] )*


## Prerequisites

### Ansible code previously pushed to S3 bucket
Once the EC2 instance starts, it will try to retrieve the ansible code from : *'s3://demo-infra-s3-bucket/admin/'*.

So before applying terraform code, you first need to make sure the Ansible code has well been copied.

    cd <terraform>/common/s3/admin/
    aws s3 sync . s3://demo-infra-s3-bucket/admin/ --exclude ".git/*" --exclude "*/.terraform/*" --delete
cf.  <terraform>/common/s3/admin/readme.md

### SSH key pair
You need to have the *'admin.pem'* private key in order to successfully connect to the 'admin' instance. 

### Your own IP address
Because this EC2 instance has full AWS access, it is a good thing to restrict its SSH access from you own IP address.
Once you identified it (ex: 12.34.56.78), edit the *\<terraform\>/\<env\>/main.tf* file and change the following variable :

    my_own_ip_address = "12.34.56.78/32"

By default, the value of this variable is 0.0.0.0/0, which is **unsafe** as SSH connection is opened to the world. 


## Connect to the 'admin' EC2 instance

    ssh -i <ssh_private_key_file> ec2-user@\<env\>-admin.codeascode.net
 example :

    ssh -i ~/.ssh/admin.pem ec2-user@dev-admin.codeascode.net


## Best practices

* Restrict SSH access to your own IP address (cf. *my_own_ip_address* variable);
* Stop your admin instances when you don't use them.

  Note that you must not destroy them as the webservers security group has a rule allowing access (all protocols, all ports) from the admin security group.


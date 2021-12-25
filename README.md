#

## Sunny Interview assignment
Made for interview purposes on AWS cloud infrastructure

##### Assignment:

1. Write a Terraform configuration (v1.0 and above) which perform the following steps:

    1.1 Create an EKS cluster with a single node

    1.2 Create RDS with MySQL DB

    1.3 Create 3 mysql databases inside the RDS we just created

    1.4 Create 4 users with select privileges to all tables

    1.5 Give all users access to all databases

Note - Verify your code is running properly, this configuration should be efficient and support any change which the user needs to perform (i.e. add new user credentials, add new schema, etc.)

2. Create a new docker image, include a mysql cli client in it and store it inside a public repository (docker hub, Amazon ECR, etc…)

3. Run the image on EKS (K8s), login into the running pod using command line and run a simple query of 'select All' over one of the tables using one or two of the users created using terraform.

---

## Notice:
Because I developed all infrastructure from Cloud9 (different VPC) I had trouble creating tables in a MySQL Instance,
after I resolved the connectivity issue with VPC Peering and routing between the subnets, all worked fine 🎉

### Prerequisites:

* Add Route within your Cloud9 VPC to a 172.16.0.0/16 CIDR (Where terraform infrastructure hosts).
* In the variables.tf update Cloud9 networking subnets if needed (I used 10.0.0.0/24 in Cloud9 VPC).

### Docker Commands used

Login to your account (Provide user & token)
    
    docker login

Build docker from [Dockerfile]("./docker/Dockerfile")
    
    docker build -t ubuntu-mysql-client .

Push created Container to my repository
    
    docker tag akpysec/mysql-client akpysec/mysql-client:latest
    docker push akpysec/ubuntu-mysql-cli

### EKS Instructions
#### Install Prerequisites:

- [IAM Athenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) 
- [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

#### Configure Instance to communicate with EKS cluster

Create & copy terraform kubeconfig output to /.kube/kubeconfig file
Instance Certificate Authentication with EKS needs a CA provided by the "terraform output kubeconfig" command (after terraform builds infrastructure).
We have to create ./kube directory and config file in it, afterwards append a kubeconfig output with certificate and other configurations.
- Take notice that the output returns 2 extra lines - first & last line <<EOT & EOT, 3-rd command takes care of it.


    mkdir /home/ec2-user/.kube
    touch /home/ec2-user/.kube/config
    terraform output kubeconfig | tail -n +2 | head -c -5 > /home/ec2-user/.kube/config

## Final POC command

Connecting to MySQL DB through EKS-Docker that Downloaded from my Repo at Dockerhub & checking for priveledges assigned.

#### Connect to DB:

![connection to DB](https://user-images.githubusercontent.com/48283299/147382338-fdec49f4-7353-4abb-b34a-2b52f29d64b2.PNG)

Permissions:

![Permissions View](https://user-images.githubusercontent.com/48283299/147382342-7e604b0f-37c5-45a9-b9c0-c8429a768421.PNG)

- Getting Endpoint with "terraform output db_endpoint" command
- Getting Password from SSM Parameter Store
      
#### Commands:

        kubectl run -it --rm --image=akpysec/ubuntu-mysql-cli:latest --restart=Never mysql-client -- mysql --host="<specify_db_endpoint>" --user="<specify_username>" --password="<spicify_password>"
        SELECT CONCAT('SHOW GRANTS FOR \'',user,'\'@\'',host,'\';') FROM mysql.user;
        SHOW GRANTS FOR 'Username'@'db_endpoint / % / localhost';

---

### Summary
1) Update 'variables.tf' with your VPC network & VPC ID if you as me use different VPC from where you run your terraform
    - Variables to update; *cloud9_vpc_id, cloud9_subnet_id, cloud9_subnet*
3) Install 'IAM Authenticator & kubectl'
4) Update ./kube/config file with configuration exported from terraform (explained ^)
5) Use one line command to connect to your MySQL through docker ^
6) Check for Permissions

#


# Sunny Interview assignment
### Made for interview purposes on AWS cloud infrastructure
#### Assignment:
    1. Write a Terraform configuration (v1.0 and above) which perform the following steps:
        
        1.1 Create an EKS cluster with a single node
        1.2 Create RDS with MySQL DB
        1.3 Create 3 mysql databases inside the RDS we just created
        1.4 Create 4 users with select privileges to all tables
        1.5 Give all users access to all databases

        Note - Verify your code is running properly, this configuration should be efficient and support any change which the user needs to perform (i.e. add new user credentials, add new schema, etc.)

    2. Create a new docker image, include a mysql cli client in it and store it inside a public repository (docker hub, Amazon ECR, etc…)

    3. Run the image on EKS (K8s), login into the running pod using command line and run a simple query of 'select All' over one of the tables using one or two of the users created using terraform.

## Notice:
Because I developed all infrastructure from Cloud9 (different VPC) I had trouble creating tables in a MySQL Instance,
after I realized the connectivity problem I had to create VPC Peering and routing between the subnets.

### Prerequisites:

* Add routing within your Cloud9 VPC to a 172.16.0.0/16 CIDR
* In the variables.tf update Cloud9 networking subnets if needed (I used 10.0.0.0/24 in Cloud9 VPC).

### Docker Commands used

Login to your account (Provide user & token)
    
    docker login

Build docker from Dockerfile
    
    docker build -t ubuntu-mysql-client .

Push created Container to my repository
    
    docker tag akpysec/mysql-client akpysec/mysql-client:latest
    docker push akpysec/ubuntu-mysql-cli

### EKS Instructions
#### Install Prerequisites:

IAM Athenticator 
https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

Kubectl 
https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

#### Create & copy terraform kubeconfig output to /.kube/kubeconfig file
    mkdir /home/ec2-user/.kube
    touch /home/ec2-user/.kube/config
    terraform output kubeconfig | tail -n +2 | head -c -5 > /home/ec2-user/.kube/config

### Final POC command
Connecting to MySQL DB through EKS-Docker that Downloaded from my Repo at Dockerhub
    
    kubectl run -it --rm --image=akpysec/ubuntu-mysql-cli:latest --restart=Never mysql-client -- mysql --host="<specify_db_endpoint>" --user="<specify_username>" --password="<spicify_password>"


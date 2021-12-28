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

### Preface:

Because I developed all infrastructure from Cloud9 (different VPC) I had trouble creating tables in a MySQL Instance,
after I resolved the connectivity issue with VPC Peering and routing between the subnets, all worked fine 🎉

Preview [Architecture](https://github.com/akpysec/Sunny/blob/master/architecture/SUNNY_ARCH_2021_V01.pdf) for better understanding of an Infrastructure flow.
#

### 🔒 Security Groups information:
    
    # EKS Cluster is hosted in 192.168.0.0/24 (Managed by AWS)
    Cloud9 Instance     (10.0.0.X/24)       >> TCP/IP 3306            >> DB Instance subnets    (172.16.100-1.X/24) // DB SG
    EKS Node(s) Subnets (172.16.200-1.X/24) >> TCP/IP 3306            >> DB Instance subnets    (172.16.100-1.X/24) // DB SG
    Cloud9 Instance     (10.0.0.X/24)       >> TCP/IP 443             >> EKS Cluster API Server (192.168.0.X/16)    // Cluster SG
    EKS Cluster         (192.168.0.0/16)    >> TCP/IP 443, 10250, 53  >> EKS Node(s) Subnets    (172.16.200-1.X/24) // Cluster SG


* Cloud9 Instance specific IP address inserted into Security Groups, also only specific routing is implied from the Cloud9 Instance and backwards.
* Cluster to Node(s) minimum ports were given, based of [Documentation](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html).

#

### Prerequisites:


- Build docker image from [Dockerfile](https://github.com/akpysec/Sunny/blob/master/docker/Dockerfile)
- Pushed the docker image to my container registry at [Dockerhub](https://hub.docker.com/repository/docker/akpysec/ubuntu-mysql-cli)

#

### Description

1) Create Cloud9 Developer environment.
2) Assign role with service specific permissions so Cloud9-Instance could create resources on it's behalf.
3) In the Cloud9 IDE go to "AWS settings" & Disable "AWS managed temporary credentials".
4) Install "IAM Authenticator & kubectl" on the Cloud9 Instance or another instance from which you are going to run SQL queries, just make sure to copy kubeconfig from terraform output to the prefered Instance. This configuration allows your instance to communicate with AWS EKS. Note, If your instance is outside of AWS use Public cluster.

    - [IAM Athenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) 
    - [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

5) Run:
    
        # Don't forget to change backend S3 bucket name
        temporary init
        terraform apply

    NOTE: Input variables accordingly to Cloud9 VPC configurations or hardcode them in "variables.tf" file (presented at the bottom of a file). Variable assignment maybe passed through one liner as such:
        
        terraform apply -var cloud9_vpc_id="INSERT_CLOUD9_VPC_ID" -var cloud9_route_table_id="INSERT_CLOUD9_ROUTE_TABLE_ID"


7) Set ./kube/config file with configuration exported from terraform:

        mkdir /home/ec2-user/.kube
        touch /home/ec2-user/.kube/config
        terraform output kubeconfig | tail -n +2 | head -c -5 > /home/ec2-user/.kube/config
        

    Now your Instance can communicate with your AWS EKS resources. If you prefer to run commands from a different instance, make sure to Install IAM Authenticator & kubectl (links provided in section 5).

8) Use kubectl to connect & execute commands on your MySQL Databases through AWS EKS Docker as such:

    - Getting Endpoint with command
 
            terraform output db_endpoint
            
    - Getting Password from SSM Parameter Store or Backend .tfstate from S3

    **kubectl** commands:

        kubectl run -it --rm --image=akpysec/ubuntu-mysql-cli:latest --restart=Never mysql-client -- mysql --host="<SPECIFY_DB_ENDPOINT>" --user="<SPECIFY_USERNAME>" --password="<SPICIFY_PASSWORD>"
    
    **MySQL** queries:
        
        # Users Permissions check
        SELECT CONCAT('SHOW GRANTS FOR \'',user,'\'@\'',host,'\';') FROM mysql.user;
        SHOW GRANTS FOR 'Username'@'db_endpoint / % / localhost';
        # Created database tables check
        SHOW DATABASES;
        
    Or make it one liner:
        
        kubectl run -it --rm --image=akpysec/ubuntu-mysql-cli:latest --restart=Never mysql-client -- mysql --host="<SPECIFY_DB_ENDPOINT>" --user="<SPECIFY_USERNAME>" --password="<SPICIFY_PASSWORD>" --execute="<SQL_QUERY>"

#

### Summary

    # Download Repository
    sudo git clone https://github.com/akpysec/Sunny
    # Change folders & files owner if needed
    # sudo chown -R ec2-user:ec2-user Sunny
    cd Sunny/
    
    # Run Terraform Template
    terraform init
    terraform apply -var cloud9_vpc_id="INSERT_CLOUD9_VPC_ID" -var cloud9_route_table_id="INSERT_CLOUD9_ROUTE_TABLE_ID"
    
    # Set up kubeconfig file
    mkdir /home/ec2-user/.kube
    touch /home/ec2-user/.kube/config
    terraform output kubeconfig | tail -n +2 | head -c -5 > /home/ec2-user/.kube/config
    
    # Run Container & Query DB
    kubectl run -it --rm --image=akpysec/ubuntu-mysql-cli:latest --restart=Never mysql-client -- mysql --host="<SPECIFY_DB_ENDPOINT>" --user="<SPECIFY_USERNAME>" --password="<SPICIFY_PASSWORD>" --execute="<SQL_QUERY>"
    
    # Example queries to run:
    # Users Permissions check
    SELECT CONCAT('SHOW GRANTS FOR \'',user,'\'@\'',host,'\';') FROM mysql.user;
    SHOW GRANTS FOR 'Username'@'db_endpoint / % / localhost';
    # Created database tables check
    SHOW DATABASES;

#

### POC:

Connecting to MySQL DB through EKS-Docker that is pulled from my Repo at Dockerhub & checking for priveledges assigned.

P.S. Docker self destructs after performing a work 💥

#### Connect to DB:

![connection to DB](https://user-images.githubusercontent.com/48283299/147382338-fdec49f4-7353-4abb-b34a-2b52f29d64b2.PNG)

#### Permissions:

![POC](https://user-images.githubusercontent.com/48283299/147395839-71175898-80c7-4fda-88e5-258132ce05eb.PNG)

#### Database tables:

![POC_DB_TABLES](https://user-images.githubusercontent.com/48283299/147400732-fd0a734d-7d3f-4976-8c9a-af8aea008cd3.PNG)

#

### Contact:
Contact me via <akpysec@gmail.com>.

#

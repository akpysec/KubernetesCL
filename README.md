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

#

### Networking:

    Cloud9 Instance (10.0.0.X/24)       >> TCP/IP 3306 >> DB Instance (172.16.100-1.X/24)
    Cloud9 Instance (10.0.0.X/24)       >> TCP/IP 443  >> EKS Cluster (172.16.200-1.X/24)
    EKS Cluster     (172.16.200-1.X/24) >> TCP/IP 3306 >> DB Instance (172.16.100-1.X/24)

#

### Prerequisites:


- Build docker from [Dockerfile]("./docker/Dockerfile")

#

### Summary

1) Create Cloud9 Developer environment.
2) Assign role with service specific permissions so Cloud9-Instance could create resources on it's behalf.
3) In the Cloud9 IDE go to "AWS settings" & Disable "AWS managed temporary credentials".
4) Update "variables.tf" file variables related to Cloud9 VPC (presented at the bottom of a file) with your Cloud9 VPC configurations.
    
    - cloud9_vpc_id
    - cloud9_subnet
    - cloud9_route_table_id
    
5) Install 'IAM Authenticator & kubectl' on the Cloud9 Instance or another instance from which you are going to run SQL queries, just make sure to copy kubeconfig from terraform output to the prefered Instance. This configuration allows your instance to communicate with AWS EKS. Note, If your instance is outside of AWS use Public cluster.

    - [IAM Athenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) 
    - [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

6) Run:
    
        terraform apply

7) Set ./kube/config file with configuration exported from terraform:

        mkdir /home/ec2-user/.kube
        touch /home/ec2-user/.kube/config
        # Take notice that the output returns 2 extra lines - first & last line <<EOT & EOT, this command takes care of it.
        terraform output kubeconfig | tail -n +2 | head -c -5 > /home/ec2-user/.kube/config
        

    Now your Instance can communicate with your AWS EKS resources. If you prefer to run commands from a different instance, make sure to Install IAM Authenticator & kubectl (links provided in section 5).

8) Use kubectl to connect & execute commands on your MySQL Databases through AWS EKS Docker as such:

    - Getting Endpoint with "terraform output db_endpoint" command
    - Getting Password from SSM Parameter Store

    **kubectl** commands:

        kubectl run -it --rm --image=akpysec/ubuntu-mysql-cli:latest --restart=Never mysql-client -- mysql --host="<specify_db_endpoint>" --user="<specify_username>" --password="<spicify_password>"
    **MySQL** queries:
        
        # Users Permissions check
        SELECT CONCAT('SHOW GRANTS FOR \'',user,'\'@\'',host,'\';') FROM mysql.user;
        SHOW GRANTS FOR 'Username'@'db_endpoint / % / localhost';
        
    Or make it one liner:
        
        kubectl run -it --rm --image=akpysec/ubuntu-mysql-cli:latest --restart=Never mysql-client -- mysql --host="<specify_db_endpoint>" --user="<specify_username>" --password="<spicify_password>" --execute="<SQL Statement>"

---

## POC:

Connecting to MySQL DB through EKS-Docker that Downloaded from my Repo at Dockerhub & checking for priveledges assigned.

#### Connect to DB:

![connection to DB](https://user-images.githubusercontent.com/48283299/147382338-fdec49f4-7353-4abb-b34a-2b52f29d64b2.PNG)

#### Permissions:

![POC](https://user-images.githubusercontent.com/48283299/147395839-71175898-80c7-4fda-88e5-258132ce05eb.PNG)

#

### Contact:
Contact me via <akpysec@gmail.com>.

#

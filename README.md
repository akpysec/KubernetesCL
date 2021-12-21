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

# Kubernetes Cluster on EKS

### 🔒 Security Groups information:
    
    # EKS Cluster is hosted in 192.168.0.0/24 (Managed by AWS)
    Cloud9 Instance     (10.0.0.X/24)       >> TCP/IP 443             >> EKS Cluster API Server (192.168.0.X/16)    // Cluster SG
    EKS Cluster         (192.168.0.0/16)    >> TCP/IP 443, 10250, 53  >> EKS Node(s) Subnets    (172.16.200-1.X/24) // Cluster SG


* Cloud9 Instance specific IP address inserted into Security Groups, also only specific routing is implied from the Cloud9 Instance and backwards.
* Cluster to Node(s) minimum ports were given, based of [Documentation](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html).

#

#### Description

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

#

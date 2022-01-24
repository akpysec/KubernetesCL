## Test Environment

Developed from Cloud9 Instance:

- Terraform EKS Private Cluster with 1 Node (Managed from Cloud9 Instance only)
- Kubernetes Deployment with Kostumize (followed [Marcel Dempers](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/kubernetes/kustomize) tutorial)

``` 
# Run Templates
kubectl apply -k kubernetes/base

# Check External Link
kubectl get svc --namespace=example
```

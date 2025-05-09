# Terraform AWS EKS Environment

[![Terraform Version](https://img.shields.io/badge/Terraform-1.6+-purple?logo=terraform)](https://www.terraform.io/)
[![AWS Region](https://img.shields.io/badge/AWS%20Region-us--west--2-orange?logo=amazon-aws)](https://aws.amazon.com/)

This repository provides a **modular Terraform implementation** to deploy a highly available and production-ready Amazon EKS environment, complete with VPC networking, IAM roles, and managed node groups.

---

## 📦 **Modules Included**

- **VPC**  
  - Public & Private Subnets across multiple AZs  
  - Internet Gateway and HA NAT Gateways  
  - Public and Private Route Tables  

- **IAM**  
  - Roles for EKS Control Plane and Worker Nodes  
  - Attached Required AWS Managed Policies  

- **EKS**  
  - EKS Control Plane (HA)  
  - Managed Node Groups with Auto Scaling  

---

## 🚀 **Deployment Steps**

1. **Initialize Terraform**

   ```bash
   terraform init
   ```
2. **Plan the Deployment**
    ```bash
    terraform plan
    ```
3. **Apply the Deployment**
    ```bash
    terrform deploy
    ```

## 📚 **Project Structure**
.
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── README.md
└── modules/
    ├── vpc/
    ├── iam/
    └── eks/

## ⚙️ **Customization**
You can adjust key variables directly in main.tf or move them into variables.tf for easier management.
**Example:**
```hcl
desired_capacity = 3
min_size         = 2
max_size         = 5
instance_types   = ["t3.medium"]
eks_version      = "1.29"
```

## ✅ **Outputs**
 - VPC ID
 - EKS Cluster Name
 - EKS API Endpoint
 - EKS Cluster Certificate Authority

## 💰 **Cost Considerations**
 - NAT Gateways are deployed per AZ to ensure high availability. Consider reducing the number of NAT Gateways for non-production environments.
 - Instance types and desired capacity in managed node groups significantly impact costs. Use t3.medium for dev/test environments and larger instances for production.
 - Enable auto-scaling carefully to prevent unintended cost spikes.
 - Evaluate Savings Plans or Reserved Instances if workloads are long-running.

## 🔒 **Security Best Practices**
 - Use Private Subnets for EKS worker nodes to avoid direct public internet exposure.
 - Apply strict Security Group and NACL rules to limit inbound and outbound traffic.
 - Rotate IAM access keys and leverage AWS Secrets Manager or Parameter Store for managing sensitive data.
 - Enable Kubernetes RBAC and limit permissions using fine-grained IAM roles for service accounts (IRSA).
 - Regularly patch your node AMIs and update the EKS control plane version to maintain security compliance.

## 📌 **Notes**
 - This setup uses managed node groups for easier lifecycle management.
 - NAT Gateways are deployed per AZ to ensure high availability.
 - Modify provider.tf to change the AWS region if needed.

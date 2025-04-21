
# 🛠️ Terraform EKS Modular Infrastructure

This project builds a fully working, production-grade Amazon EKS cluster using Terraform modules and best practices.

---

## ✅ Features

- Modular VPC
- Modular EKS Cluster & Node Groups
- Helm-deployed add-ons:
  - AWS Load Balancer Controller
  - Metrics Server
- Remote state via S3 + DynamoDB (with locking)
- Auto-generated `backend.tf`
- Smart cleanup script

---

## 🚀 Getting Started

### 1. Clone the Repo
```bash
git clone https://github.com/yourname/terraform-eks-cluster.git
cd terraform-eks-cluster/terraform
```

### 2. Set Up the Remote Backend
```bash
chmod +x setup.sh
./setup.sh
```

This script will:
- Create a timestamped S3 bucket and DynamoDB table
- Generate `backend.tf` automatically

---

### 3. Deploy the Cluster

```bash
cd examples/eks-basic
terraform init
terraform validate
terraform plan
terraform apply
```

---

### 4. Clean Up

```bash
cd terraform
chmod +x cleanup.sh
./cleanup.sh
```

This script:
- Parses `backend.tf`
- Deletes the S3 bucket and DynamoDB table
- Removes `backend.tf`

---

## 📁 Folder Structure

```
TerraformEKS/
├── modules/
│   ├── vpc/
│   ├── eks-cluster/
│   ├── eks-node-group/
│   └── eks-addons/
├── examples/
│   └── eks-basic/ <------ terraform init here
├── setup.sh <---- sets up backend
├── cleanup.sh <---- deletes backend
├── .gitignore
└── README.md
```

---

## 🧠 Notes

- Make sure your AWS CLI is configured.
- Helm add-ons require `~/.kube/config` from `aws eks update-kubeconfig`.

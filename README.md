# 📦 AWS Terraform Modules

Reusable Terraform modules for provisioning AWS infrastructure, designed to standardize, simplify, and accelerate cloud deployments.

---

## 📖 Overview

This repository provides a collection of modular Terraform components to create and manage core AWS services.
Each module is self-contained, reusable, and follows infrastructure-as-code best practices.

---

## 🧩 Available Modules

### 🔐 Identity & Access Management
- IAM – Manage IAM resources (users, roles, policies, groups, assumable roles)

### 🌐 Networking
- VPC – Create a Virtual Private Cloud with subnets, routing, and networking components
- VPC Endpoints – Configure private access to AWS services from within a VPC

### 📦 Container & Compute
- ECR – Create Elastic Container Registry repositories
- ECS Cluster – Provision an ECS cluster
- ECS Service (Fargate) – Deploy containerized applications using Fargate
- ECS Service (EC2) – Deploy containerized applications using EC2-backed ECS

### 🗄 Data & Storage
- DynamoDB – Create and manage NoSQL DynamoDB tables

### ☸️ Kubernetes
- EKS – Provision an EKS cluster with managed or self-managed worker nodes and supporting components

---

## 🏗 Design Principles

- Modular and reusable components
- Clear separation of concerns
- Cloud-native architecture aligned with AWS best practices
- Scalable and maintainable infrastructure

---

## 🚀 Usage

module "vpc" {
  source = "git::https://github.com/Move2Cloud-FR/aws-terraform-modules.git//vpc?ref=main"
}

---

## 🛠 Requirements

- Terraform ≥ 1.x
- AWS Provider
- AWS credentials configured

---

## 📜 License

To be defined

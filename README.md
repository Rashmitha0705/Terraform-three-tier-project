# AWS 3-Tier Architecture using Terraform

## Project Overview

This project deploys a production-style 3-tier architecture on AWS using Terraform.

The infrastructure consists of:

- Bastion Host
- Public Application Load Balancer
- Frontend Auto Scaling Group
- Internal Application Load Balancer
- Backend Auto Scaling Group
- Amazon RDS MySQL
- CloudWatch Monitoring
- SNS Email Alerts
- Multi-AZ High Availability Design

---

## Architecture Diagram

![Architecture Diagram](architecture/architecture-diagram.png)

---

## Architecture Flow

Internet
↓
Public ALB
↓
Frontend Auto Scaling Group
↓
Internal ALB
↓
Backend Auto Scaling Group
↓
Amazon RDS MySQL

---

## AWS Services Used

- Amazon VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- EC2 Launch Templates
- Auto Scaling Groups
- Application Load Balancers
- Amazon RDS MySQL
- Security Groups
- CloudWatch
- SNS
- Terraform

---

## Project Structure

```text
aws-3tier-terraform/

├── provider.tf
├── variables.tf
├── terraform.tfvars

├── vpc.tf
├── security-groups.tf
├── alb.tf
├── launch-templates.tf
├── autoscaling.tf
├── bastion.tf
├── rds.tf
├── monitoring.tf
├── outputs.tf

└── userdata/
    ├── frontend.sh.tpl
    └── backend.sh.tpl
```

---

### Architecture diagram

                                 INTERNET
                                     │
                                     ▼
                        ┌─────────────────────┐
                        │     Public ALB      │
                        └─────────────────────┘
                                   │
                 ┌─────────────────┴─────────────────┐
                 │                                   │
                 ▼                                   ▼

      Availability Zone 1                 Availability Zone 2

┌─────────────────────┐            ┌─────────────────────┐
│ Frontend EC2        │            │ Frontend EC2        │
│ (Nginx)             │            │ (Nginx)             │
└─────────────────────┘            └─────────────────────┘
          ▲                                   ▲
          │                                   │
          └──────── Frontend ASG ─────────────┘

                          │
                          ▼

                 ┌──────────────────┐
                 │   Internal ALB   │
                 └──────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼

┌─────────────────────┐        ┌─────────────────────┐
│ Backend EC2         │        │ Backend EC2         │
│ (Flask API)         │        │ (Flask API)         │
└─────────────────────┘        └─────────────────────┘
          ▲                               ▲
          │                               │
          └──────── Backend ASG ──────────┘

                          │
                          ▼

               ┌──────────────────────┐
               │   Amazon RDS MySQL   │
               │      Primary DB      │
               └──────────────────────┘
                          │
                          │ Replication
                          ▼
               ┌──────────────────────┐
               │ Standby DB (Multi-AZ)│
               └──────────────────────┘

Public Subnet
│
├── Bastion Host
├── Public ALB
└── NAT Gateway

Private Subnets
│
├── Frontend EC2
├── Backend EC2
└── RDS
┌──────────────────────┐
│    Bastion Host      │
└──────────────────────┘
          │
          ├── SSH → Frontend EC2
          │
          └── SSH → Backend EC2


┌──────────────────────┐
│      CloudWatch      │
└──────────────────────┘
          │
          ▼
┌──────────────────────┐
│         SNS          │
└──────────────────────┘
          │
          ▼
┌──────────────────────┐
│    Email Alerts      │
└──────────────────────┘



## Network Design

### Public Subnets

- Bastion Host
- Public Application Load Balancer
- NAT Gateway

### Frontend Private Subnets

- Frontend EC2 Instances

### Backend Private Subnets

- Backend EC2 Instances
- Amazon RDS

---

## Security Design

### Bastion Security Group

Allows:

- SSH (22) from administrator IP

### Public ALB Security Group

Allows:

- HTTP (80) from Internet

### Frontend Security Group

Allows:

- HTTP from Public ALB
- SSH from Bastion

### Internal ALB Security Group

Allows:

- HTTP from Frontend Servers

### Backend Security Group

Allows:

- HTTP from Internal ALB
- SSH from Bastion

### RDS Security Group

Allows:

- MySQL (3306) from Backend Servers only

---

## Monitoring and Alerting

CloudWatch alarms are configured for:

### Frontend ALB

- Unhealthy target count

### Backend ALB

- Unhealthy target count

### Amazon RDS

- CPU Utilization above 70%

### Notifications

Amazon SNS sends email alerts when alarms are triggered.

---

## Application Workflow

1. User accesses Public ALB
2. Public ALB forwards traffic to Frontend Instances
3. Frontend sends requests to Internal ALB
4. Internal ALB forwards traffic to Backend Instances
5. Backend Flask application queries Amazon RDS
6. Results are returned to the Frontend UI

---

## Deployment

Initialize Terraform

```bash
terraform init
```

Validate Configuration

```bash
terraform validate
```

Review Execution Plan

```bash
terraform plan
```

Deploy Infrastructure

```bash
terraform apply
```

Destroy Infrastructure

```bash
terraform destroy
```

---

## Outputs

Terraform provides:

- Bastion Public IP
- Public ALB DNS
- Internal ALB DNS
- RDS Endpoint

---


## Learning Outcomes

This project demonstrates:

- Infrastructure as Code using Terraform
- AWS Networking
- VPC Design
- Public and Private Subnets
- Application Load Balancers
- Auto Scaling Groups
- Launch Templates
- Amazon RDS
- Security Group Design
- CloudWatch Monitoring
- SNS Alerting
- High Availability Architecture

---

## Resume Highlights

- Designed and deployed a highly available AWS 3-tier architecture using Terraform.
- Implemented Public and Internal Application Load Balancers.
- Configured Auto Scaling Groups and Launch Templates for frontend and backend tiers.
- Developed a Flask-based backend integrated with Amazon RDS MySQL.
- Implemented CloudWatch monitoring and SNS-based alerting.
- Secured infrastructure using layered Security Groups and private subnet architecture.
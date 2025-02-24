# Terraform_Azure_ProjectX_IaC

# ProjectX - Azure Infrastructure as Code

This project demonstrates a modular Azure infrastructure deployment using Terraform. It implements a secure web server environment with proper networking, security, and storage configurations following infrastructure as code best practices.

## Architecture Overview

The infrastructure consists of:

- **Resource Group**: Central organizational unit for all resources (Germany West Central region)
- **Virtual Network**: Isolated network with dedicated subnets and address space 128.0.0.0/16
- **Subnets**: Separated web (128.0.1.0/24), database (128.0.2.0/24), and bastion (128.0.3.0/24) subnets
- **Network Security Group**: Firewall rules securing access to resources
- **Web Server VM**: Ubuntu 18.04 LTS with nginx automatically installed
- **Data Disk**: Separate 50GB storage for web content
- **Public IP**: Dynamic public IP for remote access and web serving

## Implementation Details

### Modular Structure

This project uses a modular approach for better organization and reusability:

- **Network Module**: Handles all networking components (VNet, subnets, NSG)
- **Compute Module**: Manages VM creation and configuration
- **Security Module**: Configures NSG rules and security associations

### Security Measures

Security is implemented through multiple layers:

- **Network Isolation**: Separated subnet architecture keeps resources logically isolated
- **NSG Rules**: Explicit allow/deny rules with proper prioritization:
  - Allow SSH (port 22) for secure administration
  - Allow HTTP (port 80) for web traffic
  - Allow HTTPS (port 443) for secure web traffic
  - Deny all other inbound traffic by default
- **SSH Key Authentication**: More secure than password-based authentication

### Automation Features

The infrastructure includes automated setup:

- Custom script installs and configures nginx web server
- Data disk is automatically formatted and mounted
- Simple welcome page is created automatically
- Service startup is configured for persistence across reboots

## Deployment Instructions

### Prerequisites

- Terraform v1.0+
- Azure CLI installed and configured with appropriate subscription
- SSH key pair (for VM authentication)

### Deployment Steps

1. Clone this repository:
   ```bash
   git clone https://github.com/Azizboudour/Terraform_Azure_ProjectX_IaC.git
   cd Terraform_Azure_ProjectX_IaC
   ```

2. Review and modify `terraform.tfvars` as needed:
   ```bash
   nano terraform.tfvars
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the execution plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

6. Access the VM:
   - For SSH access:
     ```bash
     ssh adminuser@$(terraform output -raw vm_public_ip_address)
     ```
   - For web access, open a browser and navigate to:
     ```
     http://$(terraform output -raw vm_public_ip_address)
     ```

## Infrastructure Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                     Azure (Germany West Central)                     │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                  Resource Group: projectX-rg                 │    │
│  │                                                             │    │
│  │  ┌─────────────────────────────────────────────────────┐    │    │
│  │  │           Virtual Network: projectX-vnet            │    │    │
│  │  │                  (128.0.0.0/16)                     │    │    │
│  │  │                                                     │    │    │
│  │  │  ┌──────────────┐  ┌──────────────┐  ┌───────────┐  │    │    │
│  │  │  │  Web Subnet  │  │Database Subnet│  │  Bastion  │  │    │    │
│  │  │  │(128.0.1.0/24)│  │(128.0.2.0/24)│  │(128.0.3.0)│  │    │    │
│  │  │  └──────┬───────┘  └──────────────┘  └───────────┘  │    │    │
│  │  │         │                                           │    │    │
│  │  └─────────┼───────────────────────────────────────────┘    │    │
│  │            │                                                │    │
│  │  ┌─────────┼───────────┐   ┌───────────────────────────┐   │    │
│  │  │         │           │   │  Network Security Group   │   │    │
│  │  │  ┌──────▼─────────┐ │   │                           │   │    │
│  │  │  │      VM        │ │   │  - Allow SSH (Port 22)    │   │    │
│  │  │  │ ┌────────────┐ │ │   │  - Allow HTTP (Port 80)   │   │    │
│  │  │  │ │   Nginx    │ │ │   │  - Allow HTTPS (Port 443) │   │    │
│  │  │  │ └────────────┘ │ │   │  - Deny All Other Traffic │   │    │
│  │  │  │                │ │   │                           │   │    │
│  │  │  │ ┌────────────┐ │ │   └───────────────────────────┘   │    │
│  │  │  │ │  OS Disk   │ │ │                                   │    │
│  │  │  │ └────────────┘ │ │   ┌───────────────────────────┐   │    │
│  │  │  │ ┌────────────┐ │ │   │                           │   │    │
│  │  │  │ │ Data Disk  │ │ │   │      Public IP Address    │   │    │
│  │  │  │ │  (50GB)    │ │ │   │                           │   │    │
│  │  │  │ └────────────┘ │ │   └───────────────┬───────────┘   │    │
│  │  │  └────────────────┘ │                   │               │    │
│  │  └─────────────────────┘                   │               │    │
│  │                                            │               │    │
│  └────────────────────────────────────────────┼───────────────┘    │
│                                               │                    │
└───────────────────────────────────────────────┼────────────────────┘
                                                │
                                         ┌──────▼──────┐
                                         │   Internet  │
                                         └─────────────┘
```

## Team Collaboration

This project is set up for team collaboration through GitHub:

### Workflow

1. Clone the repository
2. Create a feature branch for your changes
3. Make and test changes locally
4. Commit and push to GitHub
5. Create a pull request for team review
6. Apply changes after approval

### Best Practices

- Use descriptive commit messages
- Create meaningful branch names (e.g., `feature/add-database-server`)
- Test all changes locally before pushing
- Document significant changes in pull request descriptions
- Keep secrets and credentials out of version control

## Future Enhancements

Potential extensions to this project:

- Database server deployment in the database subnet
- Load balancer for high availability
- Application deployment automation
- Monitoring and logging implementation
- Backup and disaster recovery solutions

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Microsoft Azure Documentation
- HashiCorp Terraform Documentation
- The Infrastructure as Code community

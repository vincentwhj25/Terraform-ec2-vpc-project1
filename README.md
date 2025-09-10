# Terraform Project 1: VPC and EC2 Deployment

This project demonstrates the use of Terraform to provision a basic AWS environment.  
It creates:
- Custom VPC
- Public subnet
- Internat gatway
- Route table
- Security group allowing SSH
- EC2 instance running Amazon Linux on ap-southeast-1

## Future Improvements
- Add Key Pair for SSH access
- Use modules for better organization
- Attach EIP
- SG security restric, prevent using 0.0.0.0/0

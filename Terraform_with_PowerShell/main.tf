provider "aws" {
  region = "us-east-1"
}

terraform {
  cloud {
    organization = "TerraformVig"

    workspaces {
      name = "Ec2-Windows"
    }
  }
}

resource "aws_vpc" "Windows_Server_VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Windows-Server-VPC"
  }
}

resource "aws_internet_gateway" "Windows_Server_Gateway" {
  vpc_id = aws_vpc.Windows_Server_VPC.id

  tags = {
    Name = "Windows_Server_VPC"
  }
}

resource "aws_route_table" "Windows_Server_Route_Table" {
  vpc_id = aws_vpc.Windows_Server_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Windows_Server_Gateway.id
  }

  tags = {
    Name = "Windows_Server_Route_Table"
  }
}

resource "aws_subnet" "Windows_Server_VPC_Subnet" {
  vpc_id            = aws_vpc.Windows_Server_VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Main"
  }
}

resource "aws_route_table_association" "Windows_Server_Route_Table_Association" {
  subnet_id      = aws_subnet.Windows_Server_VPC_Subnet.id
  route_table_id = aws_route_table.Windows_Server_Route_Table.id
}

resource "aws_security_group" "Windows_Server_Security_Group" {
  name        = "Windows_Server_Security_Group"
  description = "Allow 443, 80 traffic"
  vpc_id      = aws_vpc.Windows_Server_VPC.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP from VPC"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Windows_Server_Security_Group"
  }
}

resource "aws_instance" "Windows_EC2_Instance" {
  ami                         = var.windows-server-ami
  instance_type               = var.instance-type
  availability_zone           = var.availability_zone
  subnet_id                   = aws_subnet.Windows_Server_VPC_Subnet.id
  key_name                    = "WindowsServer"
  associate_public_ip_address = "true"
  get_password_data           = true
  vpc_security_group_ids      = ["${aws_security_group.Windows_Server_Security_Group.id}"]
  user_data                   = <<EOF
              <powershell>

              Set-Location -Path "C:\Users\Administrator\Desktop"

              $Script_Url = "https://raw.githubusercontent.com/ViggoMode2021/Connecticut-Runs-On-PowerShell/main/Terraform_with_PowerShell/ec2_windows_server_setup.ps1"

              wget $Script_Url -OutFile .\EC2-UserData-Windows-Server.ps1

              $AD_Script_Url = "https://raw.githubusercontent.com/ViggoMode2021/Connecticut-Runs-On-PowerShell/main/Terraform_with_PowerShell/ec2_windows_server_setup.ps1"

              wget $AD_Script_Url -OutFile .\Active-Directory-Script.ps1

              Sleep 2

              .\EC2-UserData-Windows-Server.ps1
              
              </powershell>

              EOF

  tags = {
    Name = "Active Directory Windows EC2 instance"
  }

}

output "ip" {
  value = aws_instance.Windows_EC2_Instance.public_ip
}

#resource "aws_vpc_dhcp_options" "dns_resolver" {
#domain_name_servers = ["aws_instance.windows_ec2_instance.public_ip"]
#}

variable "region" {
  default = "us-east-1"
}

variable "instance_name" {
  description = "Name of the instance to be created"
  default     = "healthcare-claims-analytics-project"
}

variable "instance_type" {
  default = "t2.small"
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will be created in"
  default     = "subnet-98e06ac7"
}

variable "iam_instance_profile" {
  description = "IAM role for the EC2 instance to access KMS"
  default     = "EC2toKMS"
}

variable "ami_id" {
  description = "The AMI to use"
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "number_of_instances" {
  description = "number of instances to be created"
  default     = 1
}


variable "instance_key" {
  type        = string
  description = "Secure key pair to use for SSH access into the EC2 instance(s)."
  default     = "treebux-ec2-a"
  validation {
    condition     = length(var.instance_key) > 0
    error_message = "An instance key must be a declared."
  }
}

variable "user_data" {
  type    = string
  default = <<-EOF
    #!/usr/bin/bash
    sudo apt-get update

    # Install Docker
    ## Per Docker's instructions: https://docs.docker.com/en  gine/install/ubuntu/
    echo "*** Installing Docker"
    # Add Docker's official GPG key:
    apt-get -y update
    apt-get -y install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get -y update
    apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    if docker run hello-world | grep -q 'This message shows that your installation appears to be working correctly.'; then echo "*** Docker successfully installed"; else echo "*** ERROR: Docker failed to install"; fi
    echo "*** Completed Installing Docker"

    # Launch Docker containers
    echo "*** Launching Docker containers"
    git clone https://github.com/tbuck09/healthcare-claims-analytics-project.git /home/ubuntu/healthcare-claims-analytics-project
    cd /home/ubuntu/healthcare-claims-analytics-project/airflow
    git checkout iac
    ## Create directories and change ownership
    ### Logs
    mkdir -p /basic-airflow/logs
    chown -R 50000:50000 /basic-airflow/logs
    chmod -R 770 /basic-airflow/logs
    ### DAGs
    mkdir -p /basic-airflow/dags
    chown -R 50000:50000 /basic-airflow/dags
    chmod -R 770 /basic-airflow/dags
    ## Launch containers
    docker compose up -d
    echo "*** Completed Launching Docker containers"
        
    EOF
}

variable "vpc_cidr" {
  default = "178.0.0.0/16"
}
variable "public_subnet_cidr" {
  default = "178.0.10.0/24"
}

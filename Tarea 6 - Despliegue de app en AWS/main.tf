provider "aws" {
  region = "sa-east-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

variable "name" {
  default = "AWS_IIS_WIN2019"
}

resource "aws_key_pair" "main" {
  key_name   = "clouddevopsiis"
  public_key = "${file("clouddevops.pub")}"
}

resource "aws_security_group" "main" {
  name = "${var.name}-security-group"
  
  tags = {
    Name = "${var.name}-security-group"
  }
  
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami = "ami-048fe32495ea857a6"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  
  key_name = "${aws_key_pair.main.key_name}"
  
  root_block_device {
    volume_type = "gp3"
    volume_size = "30"
    delete_on_termination = true
  }

  tags = {
    "Name" = "InstanciaCloudDevopsTeam2",
    "Tipo" = "InstanciaWebServer",
    "SO" = "Windows Server2019",
    "Equipo" = "CloudDevopsTeam2",
    "Carrera" = "CloudDevOps",
    "Institución" = "EducacionIT",
    "Environment" = "Pre-Production"
  }
}
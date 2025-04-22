data "aws_ami" "al2023_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}
data "aws_ssm_parameter" "ec2_private_key" {
  name = "siva"
  with_decryption = true
}

locals {
  name = "${var.environment}-${var.project}"
  instance_name = "${local.name}-${var.instance_name}"
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.al2023_latest.id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = merge(
    {
        Name = local.name
    },
    var.common_tags
  )
}

resource "null_resource" "provision_utilities" {
  depends_on = [aws_instance.web]

  connection {
    type        = "ssh"
    host        = aws_instance.web.public_ip
    user        = "ec2-user"
    private_key = data.aws_ssm_parameter.ec2_private_key.value
  }

  provisioner "file" {
    source = "${path.module}/utilities.sh"
    destination = "/tmp/utilities.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/utilities.sh",
      "sudo /tmp/utilities.sh"
    ]
  }
  triggers = {
    script_hash = filesha256("${path.module}/utilities.sh")
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "${local.name}.konkas.tech"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web.public_ip]
}

resource "aws_security_group" "web_sg" {
  name        = "${local.name}-sg"
  description = "Security group for ${local.name}"
  vpc_id      = var.vpc_id
   ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = merge(
    {
        Name = local.name
    },
    var.common_tags
  )
}
 

############## ALB Security Group and Creation#######################
resource "aws_security_group" "alb_wp_sg" {
  name        = "WordPress_ALB_SG"
  description = "load balancer sg for WP site"
  vpc_id      = data.terraform_remote_state.infra_remote_state.outputs.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = "10.10.0.0/21"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "10.10.0.0/21"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "alb_wp" {
  name            = "WordPress_ALB"
  security_groups = [aws_security_group.alb_wp_sg.id]
  subnets         = [aws_subnet_ids.subnets.*.id]

}

#http trough the 80 port
resource "aws_alb_target_group" "group_wp" {
  name     = "terraform-example-alb-target"
  port     = 80 
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.infra_remote_state.outputs.vpc_id
}

#http we are listening on the port 80
resource "aws_alb_listener" "listener_wp" {
  load_balancer_arn = aws_alb.alb_wp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.group_wp.arn
    type             = "forward"
  }
}


data "aws_subnet_ids" "subnets" {
  vpc_id = data.terraform_remote_state.infra_remote_state.outputs.vpc_id
}

############ WebServer Security Group################################

resource "aws_security_group" "wp_sg" {
  name   = "wp_security_group"
  vpc_id = data.terraform_remote_state.infra_remote_state.outputs.vpc_id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/21"] #need to specify the IP adress but i just gave the CIDR block of the VPC
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/21"] #need to specify the IP adress but i just gave the CIDR block of the VPC
  }

  ingress {
    from_port = var.nfs_port
    to_port   = var.nfs_port
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #outbound to the world
  }
}

resource "aws_efs_file_system" "elastic_FS" {
  creation_token = "WordPress FileSystem"
}

resource "aws_efs_mount_target" "elastic_MT" {
  //count= "4" 
  //count had to be hardcoded because of dependency faliure. later this can be calculated
  count           = length(data.aws_subnet_ids.subnets.ids)
  file_system_id  = aws_efs_file_system.elastic_FS.id
  subnet_id       = element(tolist(data.aws_subnet_ids.subnets.ids), count.index)
  security_groups = [aws_security_group.wp_sg.id]
}

########### Create Web Server###########################

####For the webserver, use the latest Amazon Linux 2 AMI available###


data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "WP_site" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wp_sg.id]
  #key_name               = aws_key_pair.deployer.id
  key_name               = var.key_name
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }


  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = var.volume_size
    delete_on_termination = "true"
  }

  user_data = <<EOF
        #!/bin/bash
        echo "${aws_efs_file_system.elastic_FS.dns_name}:/ /var/www/html nfs defaults,vers=4.1 0 0" >> /etc/fstab
        yum install -y php php-dom php-gd php-mysql
        for z in {0..120}; do
            echo -n .
            host "${aws_efs_file_system.elastic_FS.dns_name}" && break
            sleep 1
        done
        cd /tmp
        wget https://www.wordpress.org/latest.tar.gz
        mount -a
        tar xzvf /tmp/latest.tar.gz --strip 1 -C /var/www/html
        rm /tmp/latest.tar.gz
        chown -R apache:apache /var/www/html
        systemctl enable httpd
        sed -i 's/#ServerName www.example.com:80/ServerName www.myblog.com:80/' /etc/httpd/conf/httpd.conf
        sed -i 's/ServerAdmin root@localhost/ServerAdmin admin@myblog.com/' /etc/httpd/conf/httpd.conf
        systemctl start httpd
    
EOF

}
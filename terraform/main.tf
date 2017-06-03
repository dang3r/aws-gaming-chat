provider "aws" {
  region = "us-east-1"
  profile = "devops"
}

resource "aws_eip" "public" {
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip_association" "link" {
  instance_id = "${aws_instance.server.id}"
  allocation_id = "${aws_eip.public.id}"
}


resource "aws_instance" "server" {
  ami = "ami-9d6c128a"
  instance_type = "t2.nano"
  key_name = "${aws_key_pair.ssh.key_name}"
  security_groups = ["${aws_security_group.base.name}"]
}

resource "aws_security_group" "base" {
  name = "base"

  ingress {
    protocol = "tcp"
    from_port = 3784
    to_port = 3784
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol = "udp"
    from_port = 9987
    to_port = 9987
    cidr_blocks = ["0.0.0.0/0"]
  }
}

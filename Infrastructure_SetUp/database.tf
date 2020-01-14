resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  db_subnet_group_name = "${aws_db_subnet_group.wordpress_subnet_group.id}"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "Stratoscale!Orchestration!"
  name                 = "bv_database"
  parameter_group_name = "mysql5.7"
}

resource "aws_db_subnet_group" "wordpress_subnet_group" {
  name       = "subnetgroup_bv"
  subnet_ids = ["${aws_subnet.private_1.id}", "${aws_subnet.private_2.id}"]
}
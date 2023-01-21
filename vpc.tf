resource "aws_vpc" "samim_main" {
 cidr_block = "192.168.0.0/16"
 
 tags = {
   Name = "samim_vpc"
 }
}


resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.samim_main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.samim_main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.samim_main.id

  tags = {
    Name = "samim_igw"
  }
}


























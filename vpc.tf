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



resource "aws_internet_gateway_attachment" "igwa" {
  internet_gateway_id = aws_internet_gateway.igwa.id
  vpc_id              = aws_vpc.samim_main.id
 
 
}



resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.samim_main.id

  route {
    cidr_block = element(var.public_subnet_cidrs, count.index)
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "samim_rt"
  }
}



















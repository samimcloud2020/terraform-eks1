resource "aws_vpc" "samim_vpc" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "samim_vpc"
 }
}
























resource "aws_vpc" "samim_main" {
  cidr_block       = "192.168.0.0/16"
  
  tags = {
    Name = "samim_vpc"
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "samim_subnet1" {
  vpc_id     = aws_vpc.samim_main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "samim_subnet1"
  }
}

resource "aws_subnet" "samim_subnet2" {
  vpc_id     = aws_vpc.samim_main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "samim_subnet2"
  }
}

resource "aws_subnet" "samim_subnet3" {
  vpc_id     = aws_vpc.samim_main.id
  availability_zone = data.aws_availability_zones.available.names[2]
  cidr_block = "192.168.3.0/24"

  tags = {
    Name = "samim_subnet3"
  }
}

resource "aws_subnet" "samim_subnet4" {
  vpc_id     = aws_vpc.samim_main.id
  availability_zone = data.aws_availability_zones.available.names[3]
  cidr_block = "192.168.4.0/24"

  tags = {
    Name = "samim_subnet4"
  }
}


resource "aws_subnet" "samim_subnet5" {
  vpc_id     = aws_vpc.samim_main.id
  availability_zone = data.aws_availability_zones.available.names[4]
  cidr_block = "192.168.5.0/24"

  tags = {
    Name = "samim_subnet5"
  }
}


resource "aws_internet_gateway" "samim_igw" {
  vpc_id = aws_vpc.samim_main.id

  tags = {
    Name = "samim_igw"
  }
}

resource "aws_internet_gateway_attachment" "samim_igwa" {
  internet_gateway_id = aws_internet_gateway.samim_igw.id
  vpc_id              = aws_vpc.samim_main.id
  
  tags = {
    Name = "samim_igwa"
  }
}


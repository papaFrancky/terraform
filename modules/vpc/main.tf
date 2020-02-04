# CLOUD PROVIDER
# --------------

provider aws {
  region      = var.region
}



#  VPC
# --------

resource aws_vpc my_vpc {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = {
    Name = var.env
    env  = var.env
  }
}


# PUBLIC SUBNET
# -------------

data aws_availability_zones all {}

resource aws_subnet public {
    count                   = length(data.aws_availability_zones.all.names)
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = cidrsubnet(var.cidr, 8, 101 + count.index)
    availability_zone	      = element(data.aws_availability_zones.all.names, count.index)
    map_public_ip_on_launch = false
    
    tags = {
      Name   = "${var.env}-public-${element(data.aws_availability_zones.all.names, count.index)}"
      env    = var.env
      subnet = "public"
    }
}



# INTERNET GATEWAY
# ----------------

resource aws_internet_gateway my_igw {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
        Name = var.env
        env  = var.env
    }
}

# PUBLIC ROUTE TABLE
# ------------------

resource aws_route_table public {
    vpc_id  = aws_vpc.my_vpc.id
 
    tags = {
        Name = "${var.env}-public"
        env  = var.env
    }
}

resource aws_route igw {
    route_table_id          = aws_route_table.public.id
    destination_cidr_block  = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.my_igw.id
}

resource aws_route_table_association public {
    count           = length(data.aws_availability_zones.all.names)
    subnet_id       = element(aws_subnet.public.*.id, count.index)
    route_table_id  = aws_route_table.public.id
}

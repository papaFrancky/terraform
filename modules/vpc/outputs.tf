# OUTPUT VARIABLES
# ----------------

output "aws_region" {
  value   = var.region
}

output "env" {
  value   = var.env
}

output "vpc_id" {
  value   = aws_vpc.my_vpc.id
}

output "public_subnets_ids" {
    value = aws_subnet.public.*.id
}

output "public_subnets_names" {
  value   = aws_subnet.public.*.tags.Name
}

output "public_cidrs" {
    value = aws_subnet.public.*.cidr_block
}


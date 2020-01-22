# modules/webservers/outputs.tf
# -----------------------------


# OUTPUT VARIABLES
# ----------------

output elb_dns_name {
  value = aws_elb.webservers.dns_name
}
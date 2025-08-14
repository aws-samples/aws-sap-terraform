resource "aws_network_interface" "this" {
  subnet_id   = var.subnet_ID
  private_ips = [var.private_ip]

  security_groups   = [var.application_code == "hana" ? data.aws_ssm_parameter.ec2_hana_sg.value : data.aws_ssm_parameter.ec2_nw_sg.value]
  source_dest_check = var.application_code == "hana" ? false : true

  tags = merge(var.ec2_tags,{
    Name = var.hostname
  })
}

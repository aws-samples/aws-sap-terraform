resource "aws_instance" "this" {
  ami                     = var.ami_ID
  instance_type           = var.instance_type
  key_name                = var.key_name
  monitoring              = var.monitoring
  ebs_optimized           = true
  disable_api_termination = true

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  tags = merge(var.ec2_tags, {Name = var.hostname, AppCode = var.application_code})

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = data.aws_ssm_parameter.ebs_kms.value
    volume_size           = var.root_ebs_size
    volume_type           = "gp3"
    tags = {
      Name       = "${var.hostname}-root"
      MountPoint = "/"
    }

  }

  iam_instance_profile = var.ha == true ? data.aws_ssm_parameter.ec2_ha_instance_profile.value : data.aws_ssm_parameter.ec2_non_ha_instance_profile.value

}

# EC2 Instances

Configuration of EC2 resources to be created for SAP on AWS workloads. 

Resource types created with this configuration:

* [EC2 instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
* [EBS Volumes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume)
* [Elastic Network Interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface)
* [DNS Record](https://www.terraform.io/docs/providers/aws/r/route53_record.html)

## Usage

Specify the list of EC2 instances to be created in the corresponding ENV.tfvars file following the example below. Check the detailed description for each variable in the section below. For SAP HANA databases, EC2 instances can be specified to be created with ***standard HANA storage configuration*** or ***custom HANA storage configuration***

## Examples

### Example 1 - creation of 2 instances (one application server, one hana database) leveraging standard storage configuration.  

You only need to specify the EC2 instance type and storage type you want to use with your HANA database. The module will dynamically identify the required EBS storage resources to be created, as per [Storage Configuration for SAP HANA](https://docs.aws.amazon.com/sap/latest/sap-hana/hana-ops-storage-config.html).

```hcl
environment = "dev"
aws_region = "us-east-1"

instances_to_create = {
    sapd01db1 = {
        "private_ip"        = "10.237.40.144"
        "domain"            = "mylab.com"        
        "application_code"  = "hana"
        "application_SID"   = "D01"
        "ha"                = false     
        "ami_ID"            = "ami-12345678901234567"
        "subnet_ID"         = "subnet-12345678901234567"
        "key_name"          = "mycmk"
        "monitoring"        = true
        "root_ebs_size"     = 80 
        "ec2_tags"          = { 
            "tag_key_1" = "tag_value_1" 
        }
        "instance_type"     = "x2iedn.xlarge"
        "hana_data_storage_type"   = "gp3" 
        "hana_logs_storage_type"   = "gp3" 
        "hana_backup_storage_type" = "st1" 
        "hana_shared_storage_type" = "gp3"
    }

    sapd01cs = {
        "private_ip"       = "10.237.40.145"
        "domain"           = "mylab.com"        
        "application_code" = "nw"
        "application_SID"  = "D01"
        "ha"               = false            
        "ami_ID"           = "ami-12345678901234567"
        "subnet_ID"        = "subnet-12345678901234567"
        "key_name"         = "mycmk"
        "monitoring"        = true        
        "root_ebs_size"    = 50
        "ec2_tags"         = { 
            "tag_key_1" = "tag_value_1" 
        }
        "instance_type"    = "c5.2xlarge"
    }
}
```

### Example 2 - creation of 1 instance (database server) leveraging a custom storage configuration

You specify the EC2 instance type and a detailed custom EBS configuration for your HANA database. The ec2module will create the EBS resources as per your specification.

```hcl
environment = "dev"
aws_region = "us-east-1"

instances_to_create = {
    sapd02db1 = {
        "private_ip"        = "10.237.40.146"
        "domain"            = "mylab.com"        
        "application_code"  = "hana"
        "application_SID"   = "D02"
        "ha"                = true     
        "ami_ID"            = "ami-12345678901234567"
        "subnet_ID"         = "subnet-12345678901234567"
        "key_name"          = "mycmk"
        "monitoring"        = true
        "root_ebs_size"     = 80 
        "ec2_tags"          = { 
            "tag_key_1" = "tag_value_1" 
        }        
        "instance_type"     = "r5.8xlarge"
        "custom_ebs_config" =  [
            {
                identifier = "data",
                disk_nb    = 3,
                disk_size  = 225,
                disk_type  = "gp2"
            },
            {
                identifier = "log",
                disk_nb    = 2,
                disk_size  = 300,
                iops       = 3000,
                throughput = 250,
                disk_type  = "gp3"
            },
            {
                identifier = "backup",
                disk_nb    = 1,
                disk_size  = 512,
                iops       = 4500,
                throughput = 750,                
                disk_type  = "gp3"
            },
            {
                identifier = "shared",
                disk_nb    = 1,
                disk_size  = 512,
                disk_type  = "gp2"
            },
            {
                identifier = "tmp",
                disk_nb    = 1,
                disk_size  = 30,
                iops       = 3000,
                throughput = 125,                
                disk_type  = "gp3"
            },
            {
                identifier = "usrsap",
                disk_nb    = 1,
                disk_size  = 60,
                iops       = 3000,
                throughput = 125,                
                disk_type  = "gp3"
            },
            {
                identifier = "swap",
                disk_nb    = 1,
                disk_size  = 20,
                iops       = 3000,
                throughput = 125,                
                disk_type  = "gp3"
            }
        ]                
    }
}
```

## Input variables

| Name | Description | Example | Required |
|------|-------------|--------|--------|
|instance_type|EC2 instance type to be created|x2iedn.4xlarge|Yes
|hana_data_storage_type|EBS storage type to be used for HANA data volumes|gp3|Yes
|hana_logs_storage_type|EBS storage type to be used for HANA log volumes|gp3|Yes
|hana_shared_storage_type|EBS storage type to be used for HANA shared volumes|gp3|Yes
|hana_backup_storage_type|EBS storage type to be used for HANA backup volume|st1|Yes
|private_ip|IP of SAP EC2 instance|10.237.40.144|No (if not specified, an IP will be dynamically assigned)
|domain|Domain EC2 instance needs to be configured with |mycorp.com|Yes
|application_code|Identifies the type of EC2 instance (use "hana" for SAP HANA, use "nw" for SAP NetWeaver Application Servers.|hana|Yes
|application_SID|SAP system SID |D01|Yes
|ha|Determines if instance will be part of a High Availability cluster. If it's true, will create the instance with an IAM role with broader permissions, required for HA. If it's false, the permissions given are narrower |true|Yes
|ami_ID|AMI ID to be used for instance creation |ami-01ee0f5d6dfe22e54|Yes
|key_name|Name of EC2 key pair to SSH into the instance |mycmk|Yes
|monitoring|If set to true, enables detailed monitoring |false|Yes
|root_ebs_size|Size of root EBS volume (in GiBs) |80|Yes
|ec2_tags|Key value map with EC2 tags common to all SAP instances | { "app"= "SAP", "cost_center"= "12345" } |No

## Parameters in AWS Systems Manager Parameter Store updated by this configuration

N/A
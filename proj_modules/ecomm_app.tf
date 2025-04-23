module "ecomm_vpc" {
    source = "./modules/vpc"
    vpc_cidr = "192.168.0.0/16"
    public_subnet_cidr = "192.168.0.0/24"
    availability_zone = "us-east-2b"
    vpc_name          = "ecomm"
}

module "ecomm_ec2" {
    source = "./modules/ec2"
    ami    = "ami-0c3b809fcf2445b6a"
    instance_type = "t2.micro"
    key_name      = "2501"
    subnet_id     = module.ecomm_vpc.public_subnet_id
    vpc_security_group_ids = [module.ecomm_vpc.web_sg_id]
    user_data     = file("ecomm-script.sh")
    instance_name = "ecomm-web-server"
}

output "ecomm_instance_ip" {
    value = module.ecomm_ec2.instance_ip
}
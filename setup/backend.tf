terraform {
  backend "s3" {
    bucket         = "my-eks-terraform-state-basheer"  # ✅ Replace this with your actual bucket name
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

module "name" {
  source = "../day7-modules"
  ami_id = var.ami_id
  type = var.type
}
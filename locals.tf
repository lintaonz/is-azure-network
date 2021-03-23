locals {
  default_common_tags = {
    cost_center        = ""
    created_using      = "Terraform"
    environment        = var.envrionment
    hours_of_operation = ""
    owner              = ""
    version            = ""
    git_repo           = "https://bitbucket.org/twgnz/is-azure-landing-zone"
    pipeline           = ""
    description        = ""
    backup             = ""
    review_date        = ""
    remove_date        = ""
    location           = "Australia East"
  }

  common_tags = merge(local.default_common_tags, var.common_tags)

  vnet_rg_name = coalesce(var.vnet_rg_name, "${var.envrionment}-vnet-rg")
}

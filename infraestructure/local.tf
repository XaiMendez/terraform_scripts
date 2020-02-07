locals{
  name_prefix = var.env
  
  default_tags = {
    Environmevarnt  = var.env
    Product         = var.product
  }
  
  asg_default_tags = 
  [
    {
      key       = "Name",
      value     = "APP-ASG",
      propagate_at_launch = ""true
      
    },
    {
      key       = "Environmnet",
      value     = var.env,
      propagate_at_launch = ""true
      
    }
  ]
}

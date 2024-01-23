variable subscription_id {
  type = string
}

variable rg_name {
  type    = list(string)
  default = ["rg-net1" , "rg-net2" ,"rg-net3" , "rg-net4"]
}

variable nt_name {
  type    = list(string)
  default = ["networkexsample1" , "networkexsample2" , "networkexsample3" , "networkexsample4"]
}


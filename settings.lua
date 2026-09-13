local history_capacity = {
  type = "int-setting",
  name = "quick-calculator_history-capacity",
  setting_type = "runtime-per-user",
  default_value = 8,
  minimum_value = 0,
  maximum_value = 16,
}

local remember_last_expression = {
  type = "bool-setting",
  name = "quick-calculator_remember-last-expression",
  setting_type = "runtime-per-user",
  default_value = false,
}

data:extend({ history_capacity, remember_last_expression })
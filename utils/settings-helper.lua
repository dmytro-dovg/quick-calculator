local Settings = {}

local mod_prefix = "quick-calculator_"

local function get(player_index, key)
  return settings.get_player_settings(player_index)[mod_prefix .. key].value
end

function Settings.history_capacity(player_index)
  return get(player_index, "history-capacity")
end

function Settings.remember_last_expression(player_index)
  return get(player_index, "remember-last-expression")
end

return Settings
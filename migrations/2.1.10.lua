local List = require "utils.list"

-- Create result_history
if not storage.players then return end

for _, player_state in pairs(storage.players) do
    player_state.result_history = List.new()
end
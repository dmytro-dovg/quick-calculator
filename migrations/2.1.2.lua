-- Rename the misspelled storage key: gui.claculator_frame -> gui.calculator_frame.
if not storage.players then return end

for _, player_state in pairs(storage.players) do
    local gui = player_state.gui
    if gui and gui.claculator_frame ~= nil then
        gui.calculator_frame = gui.claculator_frame
        ---@diagnostic disable: inject-field
        gui.claculator_frame = nil
        ---@diagnostic enable: inject-field
    end
end

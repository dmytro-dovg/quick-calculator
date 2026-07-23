local C = require "constants"
local Calculator = require "calculator"

---@class GuiState
---@field claculator_frame LuaGuiElement?
---@field input_textfield LuaGuiElement?
---@field result_textfield LuaGuiElement?
---@field cross_button LuaGuiElement?

---@class PlayerState
---@field gui GuiState

---@class ModStorage
---@field players table<integer, PlayerState>

---@type ModStorage
storage = storage

---@param player_index integer
local function show(player_index)
    local frame = storage.players[player_index].gui.claculator_frame
    if not frame then
        local player = game.get_player(player_index)
        if not player then return end
        frame = player.gui.screen.add {
            type = "frame",
            name = C.gui.main_frame,
            direction = "vertical",
        }
        frame.auto_center = true

        local section_1 = frame.add {
            type = "flow",
            direction = "horizontal",
        }
        section_1.style.top_margin = 4
        section_1.style.bottom_margin = 4
        section_1.style.vertical_align = "center"
        section_1.drag_target = frame

        local input_frame = section_1.add {
            type = "frame",
            direction = "vertical",
            style = "inside_shallow_frame",
        }
        local input_textfield = input_frame.add {
            type = "textfield",
            style = "quick-calculator_input-textfield",
            name = C.gui.input_textfield,
            lose_focus_on_confirm = true,
        }
        input_textfield.style.height = 28
        input_textfield.style.width = 240
        input_textfield.style.left_padding = 8
        input_textfield.style.right_padding = 8
        input_textfield.style.top_padding = 4
        input_textfield.style.bottom_padding = 4
        input_textfield.style.font_color = { 0.8, 0.8, 0.8 }
        input_textfield.style.font = "default-large-semibold"

        -- Close button
        local cross_button = section_1.add {
            type = "sprite-button",
            name = C.gui.cross_button,
            style = "frame_action_button",
            sprite = "utility/close",
            tooltip = "Clear",
            resize_to_sprite = false,
        }
        cross_button.style.left_margin = 8
        cross_button.style.size = 28
        cross_button.style.padding =0

        local separator = frame.add {
            type = "line",
            direction ="horizontal",
        }
        separator.style.left_margin = 0


        local section_2 = frame.add {
            type = "flow",
            direction = "horizontal",
        }
        section_2.style.vertical_align = "center"
        section_2.style.horizontal_align = "center"
        section_2.drag_target = frame

        section_2.add {
            type = "label",
            caption = "=",
            style = "quick-calculator_orange-label",
        }
        local result_textfield = section_2.add {
            type = "textfield",
            style = "quick-calculator_result-textfield",
            name = C.gui.result_textfield,
            enabled = false,
            lose_focus_on_confirm = true,
        }
        result_textfield.style.width = 240
        result_textfield.style.left_padding = 8
        result_textfield.style.top_margin = 2
        result_textfield.style.horizontal_align = "left"
        result_textfield.style.disabled_font_color = { 0.8, 0.8, 0.8 }
        result_textfield.style.font = "default-large-semibold"
        result_textfield.ignored_by_interaction = true
        frame.add {
            type = "line",
            direction ="horizontal",
        }

        local section_3 = frame.add {
            type = "flow",
            direction = "vertical",
        }
        section_3.style.vertical_align = "center"
        section_3.style.horizontal_align = "center"
        section_3.style.horizontally_stretchable = true
        section_3.drag_target = frame

        local instruction_label = section_3.add {
            type = "label",
            style = "grey_label",
            caption = "Press Esc or Enter to close"
        }
        instruction_label.style.horizontally_stretchable = true
        instruction_label.style.horizontal_align = "center"
        instruction_label.ignored_by_interaction = true

        storage.players[player_index].gui.claculator_frame = frame
        storage.players[player_index].gui.input_textfield = input_textfield
        storage.players[player_index].gui.result_textfield = result_textfield
        storage.players[player_index].gui.cross_button = cross_button

        input_textfield.focus()
        player.opened = frame
    end
end

---@param player_index integer
local function hide(player_index)
    local frame = storage.players[player_index].gui.claculator_frame
    if frame then
        frame.destroy()
        storage.players[player_index].gui = { }
    end
end

---@param player_index integer
local function toggle(player_index)
    if storage.players[player_index].gui.claculator_frame then
        hide(player_index)
    else
        show(player_index)
    end
end

---@param player_index integer
local function init_player(player_index)
    storage.players[player_index] = {
        gui = { }
    }
end

commands.add_command("qcalc", nil, function (cmd)
    local player_index = cmd.player_index
    if not player_index or player_index < 1 then return end
    toggle(player_index)
end)

script.on_init(function()
    storage.players = { }
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    init_player(event.player_index)
end)

script.on_event("quick-calculator-toggle", function(event)
    ---@diagnostic disable: undefined-field
    local player_index = event.player_index
    ---@diagnostic enable: undefined-field
    if not player_index or player_index < 1 then return end
    toggle(player_index)
end)

script.on_event(defines.events.on_gui_text_changed, function (event)
    if event.element.name ~= C.gui.input_textfield then return end
    local result_textfield = storage.players[event.player_index].gui.result_textfield
    if not result_textfield then return end

    local text = event.text
    if text:len() == 0 then
        result_textfield.text = ""
    end

    local success, result = pcall(Calculator.parseExpression, text)
    if success then
        C.d("Result: "  .. result)
        result_textfield.text = tostring(result)
    else
        C.d("Error: " .. result)
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name ~= C.gui.cross_button then return end
    local input_textfield = storage.players[event.player_index].gui.input_textfield
    local result_textfield = storage.players[event.player_index].gui.result_textfield
    if input_textfield then
        input_textfield.text = ""
        input_textfield.focus()
    end
    if result_textfield then result_textfield.text = "" end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    if event.element.name ~= C.gui.main_frame then return end
    hide(event.player_index)
end)

script.on_event(defines.events.on_gui_confirmed, function (event)
    if event.element.name ~= C.gui.input_textfield then return end
    hide(event.player_index)
end)

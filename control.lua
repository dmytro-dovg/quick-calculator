local C = require "constants"
local Utility = require "utility"
local Calculator = require "calculator"

---@class GuiState
---@field calculator_frame LuaGuiElement?
---@field input_frame LuaGuiElement?
---@field input_textfield LuaGuiElement?
---@field result_textfield LuaGuiElement?
---@field cross_button LuaGuiElement?
---@field warning_icon LuaGuiElement?

---@class PlayerState
---@field gui GuiState

---@class ModStorage
---@field players table<integer, PlayerState>

---@type ModStorage
storage = storage

---Determine if an element is a descendant of another element
---@param element LuaGuiElement
---@param ancestor LuaGuiElement
---@return boolean
local function is_descendant(element, ancestor)
    local current_parent = element.parent
    while current_parent ~= nil do
        if current_parent == ancestor then return true end
        current_parent = current_parent.parent
    end
    return false
end

---@param player_index integer
---@return GuiState?
local function player_gui_state(player_index)
    local state = storage.players[player_index]
    return state and state.gui
end

---@param player_index integer
local function show(player_index)
    local gui_state = player_gui_state(player_index)
    if not gui_state then return end
    local frame = gui_state.calculator_frame
    if not frame then
        local player = game.get_player(player_index)
        if not player then return end

        frame = player.gui.screen.add {
            type = "frame",
            name = C.gui.main_frame,
            direction = "vertical",
        }
        frame.style.padding = 0
        frame.auto_center = true

        local content = frame.add { type = "flow", direction = "vertical", }
        content.style.padding = 0
        content.style.bottom_margin = 0

        -- == Section 1 ==
        local section_1 = content.add { type = "flow", direction = "horizontal", }
        section_1.style.margin = 0
        section_1.style.bottom_margin = 4
        section_1.style.padding = 8
        section_1.style.bottom_padding = 0
        section_1.style.vertical_align = "center"

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
        input_textfield.style.width = 320
        input_textfield.style.left_padding = 8
        input_textfield.style.right_padding = 8
        input_textfield.style.top_padding = 4
        input_textfield.style.bottom_padding = 4
        input_textfield.style.font_color = { 0.8, 0.8, 0.8 }
        input_textfield.style.font = "default-large-semibold"

        local cross_button = section_1.add {
            type = "sprite-button",
            name = C.gui.cross_button,
            style = "frame_action_button",
            sprite = "utility/close",
            tooltip = { "gui-quick-calculator.clear-tooltip" },
            resize_to_sprite = false,
        }
        cross_button.style.left_margin = 8
        cross_button.style.size = 28
        cross_button.style.padding =0

        local separator_1 = content.add { type = "line", direction ="horizontal", }
        separator_1.style.left_margin = 0

        -- == Section 2 ==
        local section_2 = content.add { type = "flow", direction = "horizontal", }
        section_2.style.top_padding = 2
        section_2.style.left_padding = 8
        section_2.style.right_padding = 8
        section_2.style.horizontal_align = "center"
        section_2.style.vertical_align = "center"

        local result_label = section_2.add {
            type = "label",
            caption = { "gui-quick-calculator.result_label" },
            style = "quick-calculator_orange-label",
        }
        result_label.style.vertical_align = "center"
        result_label.style.bottom_padding = 4

        local result_textfield = section_2.add {
            type = "textfield",
            style = "quick-calculator_result-textfield",
            name = C.gui.result_textfield,
        }
        result_textfield.read_only = true
        result_textfield.selectable = true
        result_textfield.style.horizontal_align = "left"
        result_textfield.style.font_color = { 0.8, 0.8, 0.8 }
        result_textfield.style.font = "default-large-semibold"
        result_textfield.style.horizontally_stretchable = true
        result_textfield.style.maximal_width = 0

        local icons = section_2.add { type = "flow", direction = "horizontal", }
        icons.style.vertical_align = "center"
        local warning_icon = icons.add {
            type = "sprite",
            sprite = "utility/warning_white",
            visible = false,
        }
        local info_icon = icons.add {
            type = "sprite",
            sprite = "quick-calculator_info",
            tooltip = { "gui-quick-calculator.info-tooltip" },
        }

        local separator_2 = content.add { type = "line", direction ="horizontal", }

        -- == Section 3 ==
        local section_3 = content.add { type = "flow", direction = "horizontal", }
        section_3.style.bottom_padding = 2
        section_3.style.vertical_align = "center"
        section_3.style.horizontal_align = "center"
        section_3.style.horizontally_stretchable = true

        local dragger_1 = section_3.add { type = "empty-widget", style = "draggable_space" }
        dragger_1.style.vertically_stretchable = true
        dragger_1.style.horizontally_stretchable = true

        local instruction_label = section_3.add {
            type = "label",
            style = "grey_label",
            caption = { "gui-quick-calculator.instructions" },
        }
        instruction_label.style.margin = 0
        instruction_label.style.horizontally_squashable = true

        local dragger_2 = section_3.add { type = "empty-widget", style = "draggable_space_header" }
        dragger_2.style.horizontally_stretchable = true
        dragger_2.style.vertically_stretchable = true

        for _, element in pairs({ section_3, separator_1, separator_2, result_label, instruction_label }) do
            element.ignored_by_interaction = true
        end

        content.drag_target = frame

        gui_state.calculator_frame = frame
        gui_state.input_frame = input_frame
        gui_state.input_textfield = input_textfield
        gui_state.result_textfield = result_textfield
        gui_state.cross_button = cross_button
        gui_state.warning_icon = warning_icon

        input_textfield.focus()
        player.opened = frame
        player.set_shortcut_toggled(C.toggle_shortcut, true)
    end
end

---@param player_index integer
local function hide(player_index)
    local gui_state = player_gui_state(player_index)
    if not gui_state then return end
    local frame = gui_state.calculator_frame
    if frame then
        frame.destroy()
        storage.players[player_index].gui = { }
        local player = game.get_player(player_index)
        if player then
            player.set_shortcut_toggled(C.toggle_shortcut, false)
        end
    end
end

---@param player_index integer?
local function toggle(player_index)
    if not player_index or player_index < 1 then return end
    local gui_state = player_gui_state(player_index)
    if gui_state and gui_state.calculator_frame then
        hide(player_index)
    else
        show(player_index)
    end
end

---@param player_index integer
local function init_player(player_index)
    storage.players = storage.players or { }
    if storage.players[player_index] then return end
    storage.players[player_index] = {
        gui = { }
    }
end

---@param is_error boolean?
---@return PrintSettings
local function command_print_settings(is_error)
    is_error = is_error or false
    return {
        game_state = false,
        sound = is_error and defines.print_sound.use_player_settings or defines.print_sound.never,
        color = is_error and { 0.9, 0.35, 0.0, } or { 1.0, 1.0, 1.0, },
    }
end

---@param command CustomCommandData
local function process_calculate_command(command)
    local player_index = command.player_index
    if not player_index then return end
    local player = game.get_player(player_index)
    if player and command.parameter then
        local success, result = pcall(Calculator.parseExpression, command.parameter)
        if success and result then
            player.print(command.parameter .. " = " .. result, command_print_settings())
        else
            if type(result) == "table" then
                player.print(Utility.localise_parse_error(result), command_print_settings(true))
            end
        end
        return
    end

    -- Only show GUI to players
    if player_index > 0 then
        toggle(command.player_index)
    end
end

commands.add_command("qcalc", { "command-help.qcalc", "qcalc" }, function (command)
    process_calculate_command(command)
end)

script.on_event("quick-calculator-toggle", function(event)
    ---@diagnostic disable: undefined-field
    toggle(event.player_index)
    ---@diagnostic enable: undefined-field
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name ~= C.toggle_shortcut then return end
    toggle(event.player_index)
end)

script.on_event(defines.events.on_gui_text_changed, function (event)
    if event.element.name ~= C.gui.input_textfield then return end

    local gui_state = player_gui_state(event.player_index)
    if not gui_state then return end

    local result_textfield = gui_state.result_textfield
    if not result_textfield then return end

    local text = event.text
    if text:len() == 0 then
        result_textfield.text = ""
        gui_state.warning_icon.visible = false
        return
    end

    local success, result = pcall(Calculator.parseExpression, text)
    local warning_icon = gui_state.warning_icon
    if success and result then
        Utility.d("Result: "  .. result)
        warning_icon.visible = false
        result_textfield.text = tostring(result)
    else
        if type(result) == "table" then
            Utility.d("Error: " .. (result.code))
            warning_icon.visible = true
            warning_icon.tooltip = Utility.localise_parse_error(result)
        end
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    local gui_state = player_gui_state(event.player_index)
    if not gui_state then return end

    local main_frame = gui_state.calculator_frame
    if not main_frame then return end

    local input_textfield = gui_state.input_textfield
    local result_textfield = gui_state.result_textfield
    local cross_button = gui_state.cross_button

    -- Refocus on input textfield
    if is_descendant(event.element, main_frame) and input_textfield and result_textfield and event.element ~= result_textfield then
        input_textfield.focus()
    end

    -- Clear button
    if event.element ~= cross_button then return end
    local warning_icon = gui_state.warning_icon
    if input_textfield then
        input_textfield.text = ""
        if warning_icon then warning_icon.visible = false end
        input_textfield.focus()
    end
    if result_textfield then result_textfield.text = "" end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local element = event.element
    if not element then return end
    if element.name ~= C.gui.main_frame then return end
    hide(event.player_index)
end)

script.on_event(defines.events.on_gui_confirmed, function (event)
    if event.element.name ~= C.gui.input_textfield then return end
    hide(event.player_index)
end)

script.on_init(function()
    for _, player in pairs(game.connected_players) do
        init_player(player.index)
    end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    init_player(event.player_index)
end)

script.on_event(defines.events.on_player_left_game, function(event)
    hide(event.player_index)
    storage.players[event.player_index] = nil
end)

script.on_configuration_changed(function(event)
    -- Close all open windows
    if not storage.players then return end
    for _, state in pairs(storage.players) do
        local frame = state.gui.calculator_frame
        if frame then frame.destroy() end
        state.gui = { }
    end
end)

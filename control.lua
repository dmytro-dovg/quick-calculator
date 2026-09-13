local C = require "constants"
local Utility = require "utility"
local Calculator = require "calculator"
local List = require "utils.list"
local Settings = require "utils.settings-helper"

--- @class HistoryEntry
--- @field tick MapTick
--- @field expression string
--- @field result string

---@class GuiState
---@field calculator_frame LuaGuiElement?
---@field input_frame LuaGuiElement?
---@field input_textfield LuaGuiElement?
---@field result_textfield LuaGuiElement?
---@field cross_button LuaGuiElement?
---@field warning_icon LuaGuiElement?
---@field history_section LuaGuiElement?
---@field history_separator LuaGuiElement?

---@class PlayerState
---@field gui GuiState
---@field result_history List<HistoryEntry>
---@field last_result HistoryEntry?
---@field history_toggled boolean

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
    local state = storage.players[player_index]
    if not state then return end

    local gui_state = state.gui
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
        -- == History section ==
        local has_history = List.length(state.result_history) > 0
        local show_history = has_history and (state.history_toggled or false)
        local history_section = content.add { type = "frame", style = "inside_shallow_frame", }
        history_section.visible = show_history

        history_section.style.margin = 8
        history_section.style.padding = 4
        history_section.style.left_padding = 8
        history_section.style.right_padding = 8
        local history_pane = history_section.add { type = "scroll-pane", direction = "vertical" }

        for i = state.result_history.first, state.result_history.last do
            if i ~= state.result_history.first then
                history_pane.add { type = "line", direction ="horizontal", }
            end
            local entry_flow = history_pane.add { type = "flow", direction = "horizontal", name=C.gui.history.flow .. tostring(i) }
            entry_flow.add {
                type = "label",
                caption = state.result_history[i].expression,
                style = "quick-calculator_history-entry-label",
                name = C.gui.history.expression_label .. tostring(i),
            }
            local empty_space = entry_flow.add { type = "empty-widget", }
            empty_space.style.horizontally_stretchable = true
            entry_flow.add {
                type = "label",
                caption = state.result_history[i].result,
                style = "quick-calculator_history-entry-label",
                name = C.gui.history.result_label .. tostring(i),
            }
        end

        local separator_1 = content.add { type = "line", direction ="horizontal", }
        separator_1.style.left_margin = 0
        separator_1.visible = show_history

        -- == Input section ==
        local input_section = content.add { type = "flow", direction = "horizontal", }
        input_section.style.margin = 0
        input_section.style.bottom_margin = 4
        input_section.style.padding = 8
        input_section.style.bottom_padding = 0
        input_section.style.vertical_align = "center"

        local input_frame = input_section.add {
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
        input_textfield.style.font = "quick-calculator-mono-18"

        local cross_button = input_section.add {
            type = "sprite-button",
            name = C.gui.cross_button,
            style = "frame_action_button",
            sprite = "quick-calculator_tag-cross",
            tooltip = { "gui-quick-calculator.clear-tooltip" },
            resize_to_sprite = false,
        }
        cross_button.style.left_margin = 8
        cross_button.style.size = 28
        cross_button.style.padding = 0

        if Settings.history_capacity(player_index) > 0 then
            local history_button = input_section.add {
                type = "sprite-button",
                name = C.gui.history_button,
                style = "frame_action_button",
                sprite = "quick-calculator_history",
                tooltip = { "gui-quick-calculator.history-tooltip" },
                resize_to_sprite = false,
            }

            history_button.style.left_margin = 8
            history_button.style.size = 28
            history_button.style.padding = 0
            history_button.enabled = has_history
            history_button.toggled = show_history
        end

        local separator_2 = content.add { type = "line", direction ="horizontal", }
        separator_2.style.left_margin = 0

        -- == Result section ==
        local result_section = content.add { type = "flow", direction = "horizontal", }
        result_section.style.top_padding = 2
        result_section.style.left_padding = 8
        result_section.style.right_padding = 8
        result_section.style.horizontal_align = "center"
        result_section.style.vertical_align = "center"

        local result_label = result_section.add {
            type = "label",
            caption = { "gui-quick-calculator.result_label" },
            style = "quick-calculator_orange-label",
        }
        result_label.style.vertical_align = "center"
        result_label.style.bottom_padding = 2

        local result_textfield = result_section.add {
            type = "text-box",
            style = "quick-calculator_result-textfield",
            name = C.gui.result_textfield,
        }
        result_textfield.read_only = true
        result_textfield.selectable = true
        result_textfield.style.horizontal_align = "left"
        result_textfield.style.font_color = { 0.8, 0.8, 0.8 }
        result_textfield.style.font = "quick-calculator-mono-18"
        result_textfield.style.horizontally_stretchable = true
        result_textfield.style.maximal_width = 0

        local icons = result_section.add { type = "flow", direction = "horizontal", }
        icons.style.vertical_align = "center"
        local warning_icon = icons.add {
            type = "sprite",
            sprite = "quick-calculator_warn",
            visible = false,
        }

        -- Info icon and tooltip
        local info_tooltip = { "" }
        local has_section = false
        ---@param key string locale key suffix
        local function add_section(key)
            if has_section then table.insert(info_tooltip, "\n\n") end
            has_section = true
            table.insert(info_tooltip, { "gui-quick-calculator.info-tooltip-section", { "gui-quick-calculator." .. key } })
        end
        ---@param key string locale key suffix
        ---@param symbols string items
        local function add_row(key, symbols)
            table.insert(info_tooltip, {
                "gui-quick-calculator.info-tooltip-row",
                { "gui-quick-calculator." .. key },
                Utility.highlight(symbols, "blue"),
            })
        end
        ---@param symbols string list of names
        local function add_list(symbols)
            table.insert(info_tooltip, { "gui-quick-calculator.info-tooltip-list", Utility.highlight(symbols, "blue") })
        end

        add_section("info-section-numbers")
        add_row("info-row-decimal", "42 3.14 .5")
        add_row("info-row-scientific", "2e3 1.5e-4")
        add_row("info-row-si", Utility.sorted_keys_by_value(Calculator.si_suffixes))
        add_row("info-row-bases", "0xFF 0b1010 0o17")

        add_section("info-section-operations")
        add_row("info-row-basic", "+ - * /")
        add_row("info-row-modulo", "%")
        add_row("info-row-exponent", "^ **")
        add_row("info-row-factorial", "!")
        add_row("info-row-grouping", "( )")
        add_row("info-row-absolute", "| |")
        add_row("info-row-functions", Utility.sorted_keys(Calculator.functions))

        add_section("info-section-constants")
        add_list(Utility.sorted_keys(Calculator.constants))

        icons.add {
            type = "sprite",
            sprite = "quick-calculator_info",
            tooltip = info_tooltip,
        }

        local separator_3 = content.add { type = "line", direction ="horizontal", }

        -- == Bottom section ==
        local bottom_section = content.add { type = "flow", direction = "horizontal", }
        bottom_section.style.bottom_padding = 2
        bottom_section.style.vertical_align = "center"
        bottom_section.style.horizontal_align = "center"
        bottom_section.style.horizontally_stretchable = true

        local dragger_1 = bottom_section.add { type = "empty-widget", style = "draggable_space" }
        dragger_1.style.vertically_stretchable = true
        dragger_1.style.horizontally_stretchable = true

        local instruction_label = bottom_section.add {
            type = "label",
            style = "grey_label",
            caption = { "gui-quick-calculator.instructions" },
        }
        instruction_label.style.margin = 0
        instruction_label.style.horizontally_squashable = true

        local dragger_2 = bottom_section.add { type = "empty-widget", style = "draggable_space_header" }
        dragger_2.style.horizontally_stretchable = true
        dragger_2.style.vertically_stretchable = true

        for _, element in pairs({ bottom_section, separator_1, separator_2, separator_3, result_label, instruction_label }) do
            element.ignored_by_interaction = true
        end

        if Settings.remember_last_expression(player_index) and state.last_result then
            input_textfield.text = state.last_result.expression
            result_textfield.text = state.last_result.result
        end

        content.drag_target = frame

        gui_state.calculator_frame = frame
        gui_state.input_frame = input_frame
        gui_state.input_textfield = input_textfield
        gui_state.result_textfield = result_textfield
        gui_state.cross_button = cross_button
        gui_state.warning_icon = warning_icon
        gui_state.history_section = history_section
        gui_state.history_separator = separator_1

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
        gui = { },
        result_history = List.new(),
        history_toggled = false,
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

---@diagnostic disable-next-line: assign-type-mismatch
commands.add_command("qcalc", { "command-help.qcalc", "qcalc" }, function (command)
    process_calculate_command(command)
end)

script.on_event("quick-calculator-toggle", function(event)
    ---@diagnostic disable-next-line: undefined-field
    toggle(event.player_index)
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name ~= C.toggle_shortcut then return end
    toggle(event.player_index)
end)


script.on_event(defines.events.on_gui_text_changed, function (event)
    if event.element.name ~= C.gui.input_textfield then return end

    local state = storage.players[event.player_index]
    if not state then return end

    local gui_state = state.gui
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
        local result_string = tostring(result)
        Utility.d("Result: "  .. result_string)
        warning_icon.visible = false
        result_textfield.text = result_string
    else
        if type(result) == "table" then
            Utility.d("Error: " .. (result.code))
            warning_icon.visible = true
            warning_icon.tooltip = Utility.localise_parse_error(result)
        end
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    local state = storage.players[event.player_index]
    if not state then return end

    local gui_state = state.gui
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

    -- Toggle history panel
    if event.element.name == C.gui.history_button then
        state.history_toggled = not state.history_toggled
        gui_state.history_section.visible = state.history_toggled
        gui_state.history_separator.visible = state.history_toggled
        event.element.toggled = state.history_toggled
        return
    end

    -- History
    local history_entry_index = tonumber(event.element.name:match(C.gui.history.pattern))
    if history_entry_index then
        local history_entry = state.result_history[history_entry_index]
        input_textfield.text = history_entry.expression
        result_textfield.text = history_entry.result
        return
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

    local state = storage.players[event.player_index]
    if not state then return end

    local success, result = pcall(Calculator.parseExpression, event.element.text)
    if success and result then
        local entry = { expression = event.element.text, result = tostring(result), tick = event.tick }
        state.last_result = entry

        -- Only store an expression if it's different from the last
        if List.length(state.result_history) == 0
            or state.result_history[state.result_history.last].expression ~= entry.expression then
            List.pushright(state.result_history, entry)
        end

        if List.length(state.result_history) > Settings.history_capacity(event.player_index) then
            List.popleft(state.result_history)
        end
    end

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

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting ~= "quick-calculator_history-capacity" then return end

    local state = storage.players[event.player_index]
    if not state then return end

    -- Trim history according to new settings
    while List.length(state.result_history) > Settings.history_capacity(event.player_index) do
        List.popleft(state.result_history)
    end
end)

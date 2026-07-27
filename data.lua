
data:extend({
    {
        type = "font",
        name = "quick-calculator_orange-large",
        from = "default-semibold",
        size = 20
    },
    {
        type = "sprite",
        name = "quick-calculator_info",
        filename = "__base__/graphics/icons/info.png",
        size = 32,
        scale = 0.5,
        mipmap_count = 3,
        position = { 64, 0 },
        flags = {"gui-icon"},
    },
})

local styles = data.raw["gui-style"].default

styles["quick-calculator_input-textfield"] = {
    type = "textbox_style",
    padding = 0,
    default_background = {
        base = {
            filename = "__quick-calculator__/graphics/textfield_background.png",
            corner_size = 2,
            position = { 0, 0 },
        },
    },
    active_background = {
        base = {
            filename = "__quick-calculator__/graphics/textfield_active-background.png",
            corner_size = 2,
            position = { 0, 0 },
        },
    },
    disabled_background = {
        base = {
            filename = "__quick-calculator__/graphics/textfield_background.png",
            corner_size = 2,
            position = { 0, 0 },
        },
    },
}

styles["quick-calculator_result-textfield"] = {
    type = "textbox_style",
    padding = 0,
    default_background = { },
    active_background = { },
    disabled_background = { },
}

styles["quick-calculator_orange-label"] = {
    type = "label_style",
    parent = "orange_label",
    font = "quick-calculator_orange-large",
}

local toggle = {
    type = "custom-input",
    name = "quick-calculator-toggle",
    key_sequence = "CONTROL + ALT + C",
}

local shortcut = {
    type = "shortcut",
    name = "quick-calculator-toggle",
    order = "f[quick-calculator]",
    style = "default",
    action = "lua",
    localised_name = {"shortcut-name.quick-calculator"},
    associated_control_input = "quick-calculator-toggle",
    toggleable = true,
    icon = "__quick-calculator__/graphics/icons/shortcut-toolbar/mip/calculator-x56.png",
    icon_size = 56,
    small_icon = "__quick-calculator__/graphics/icons/shortcut-toolbar/mip/calculator-x24.png",
    small_icon_size = 24,
}

data:extend({ toggle, shortcut, })

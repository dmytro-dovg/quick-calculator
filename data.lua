
data:extend({
  {
    type = "font",
    name = "quick-calculator_orange-large",
    from = "default-semibold",
    size = 20
  }
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

data:extend({ toggle })
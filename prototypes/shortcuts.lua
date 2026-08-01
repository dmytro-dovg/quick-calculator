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

data:extend({ shortcut, })


local info = {
    type = "sprite",
    name = "quick-calculator_info",
    filename = "__base__/graphics/icons/info.png",
    size = 32,
    scale = 0.5,
    mipmap_count = 3,
    position = { 64, 0 },
    flags = {"gui-icon"},
}

local warn = {
    type = "sprite",
    name = "quick-calculator_warn",
    filename = "__quick-calculator__/graphics/icons/warn.png",
    size = 32,
    scale = 0.5,
    mipmap_count = 3,
    flags = {"gui-icon"},
}

local tag_cross = {
    type = "sprite",
    name = "quick-calculator_tag-cross",
    filename = "__quick-calculator__/graphics/icons/tag_cross.png",
    size = 56,
    scale = 0.5,
    mipmap_count = 2,
    flags = {"gui-icon"},
}

data:extend({ info, warn, tag_cross, })

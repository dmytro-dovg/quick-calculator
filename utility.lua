
local C = require "constants"
local Utility = {}

function Utility.d(msg)
    if not C.debug.logging_enabled then return end
    local message = "[quick-calculator]: " .. msg
    localised_print(message)
end

---@param t table
---@return string
function Utility.sorted_keys(t)
    local keys = {}
    for key in pairs(t) do keys[#keys + 1] = tostring(key) end
    table.sort(keys)
    return table.concat(keys, " ")
end

---@param t table<string, number>
---@return string
function Utility.sorted_keys_by_value(t)
    local keys = {}
    for key in pairs(t) do keys[#keys + 1] = key end
    table.sort(keys, function(a, b) return t[a] < t[b] end)
    return table.concat(keys, " ")
end

---@param text string
---@param color string?
function Utility.highlight(text, color)
    local result = "[font=quick-calculator-mono-12]" .. text .. "[/font]"
    if color then
        result = "[color="  .. color .. "]" .. result .. "[/color]"
    end
    return result
end

---@param err table | string error raised by Calculator.parseExpression
---@return LocalisedString
function Utility.localise_parse_error(err)
    if type(err) ~= "table" or not err.code then
        return { "quick-calculator-error.unexpected", tostring(err) }
    end
    local detail
    if err.value ~= nil then
        detail = { "quick-calculator-error." .. err.code }
        if type(err.value) == "table" then
            for _, value in ipairs(err.value) do
                table.insert(detail, Utility.highlight(tostring(value), "yellow"))
            end
        else
            table.insert(detail, Utility.highlight(tostring(err.value), "red"))
        end
    else
        detail = { "quick-calculator-error." .. err.code }
    end
    return { "quick-calculator-error.parse-error", Utility.highlight(err.position, "yellow"), detail }
end
return Utility

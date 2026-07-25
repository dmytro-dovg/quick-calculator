
local C = require "constants"
local Utility = {}

function Utility.d(msg)
    if not C.debug.logging_enabled then return end
    local message = "[quick-calculator]: " .. msg
    localised_print(message)
end

---@param err table | string error raised by Calculator.parseExpression
---@return LocalisedString
function Utility.localise_parse_error(err)
    if type(err) ~= "table" or not err.code then
        return { "quick-calculator-error.unexpected", tostring(err) }
    end
    local detail
    if err.value ~= nil then
        detail = { "quick-calculator-error." .. err.code, tostring(err.value) }
    else
        detail = { "quick-calculator-error." .. err.code }
    end
    return { "quick-calculator-error.parse-error", err.position, detail }
end
return Utility

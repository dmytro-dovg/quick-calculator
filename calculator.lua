local Calculator = {}

local functions = {
    sqrt = math.sqrt,
    abs = math.abs,
    exp = math.exp,
    ln = math.log,
    log = function(x) return math.log(x, 10) end,
    sin = math.sin,
    cos = math.cos,
    tan = math.tan,
    asin = math.asin,
    acos = math.acos,
    atan = math.atan,
    floor = math.floor,
    ceil = math.ceil,
    rad = math.rad,
    deg = math.deg,
}

local constants = {
    pi = math.pi,
    e  = math.exp(1),
}

Calculator.Error = {
    EXPECTED_NUMBER = "expected-number",
    INVALID_NUMBER = "invalid-number",
    FACTORIAL_NEGATIVE = "factorial-negative",
    FACTORIAL_NON_INTEGER = "factorial-non-integer",
    EXPECTED_CLOSING_PAREN = "expected-closing-paren",
    EXPECTED_OPENING_PAREN = "expected-opening-paren",
    UNEXPECTED_END = "unexpected-end",
    UNKNOWN_FUNCTION = "unknown-function",
    UNKNOWN_IDENTIFIER = "unknown-identifier",
    DIVISION_BY_ZERO = "division-by-zero",
    MODULO_BY_ZERO = "modulo-by-zero",
    UNEXPECTED_TRAILING_INPUT = "unexpected-trailing-input",
}
local Error = Calculator.Error

--- Parse and evaluate an arithmetic expression string.
---
--- Supported syntax:
---   * Arithmetic:   + - * / %
---   * Unary signs:  -x, +x
---   * Exponent:     ^ or **
---   * Factorial:    x! (single "!" only)
---   * Grouping:     ( )
---   * Functions:    sqrt, abs, exp, ln, log, sin, cos, tan, asin, acos,
---                   atan, floor, ceil, rad, deg (trig in radians)
---   * Constants:    pi, e
---@param expression string
---@return number?
function Calculator.parseExpression(expression)
    local cursor = 1

    local function advance(n)
        n = n or 1
        cursor = cursor + n
    end

    ---@param code string one of Calculator.Error
    ---@param value any? optional detail for the message
    local function fail(code, value)
        error({ code = code, position = cursor, value = value }, 0)
    end

    local function skip_spaces()
        while expression:sub(cursor, cursor) == " " do advance() end
    end

    local function next_characters(n)
        skip_spaces()
        return expression:sub(cursor, cursor + n - 1)
    end

    local function next_character()
        return next_characters(1)
    end

    local function consumeNumber()
        skip_spaces()
        local start = cursor
        while expression:sub(cursor, cursor):match("[%d%.eE]") do advance() end
        if cursor == start then
            fail(Error.EXPECTED_NUMBER)
        end
        -- Handle scientific notation
        if expression:sub(cursor - 1, cursor - 1):lower() == 'e' then
            if next_character():match("[+-]") then
                advance()
                -- Decimal point will be caught by INVALID_NUMBER error
                while expression:sub(cursor, cursor):match("[%d%.]") do advance() end
            end
        end
        local num = tonumber(expression:sub(start, cursor - 1))
        if not num then
            fail(Error.INVALID_NUMBER, expression:sub(start, cursor - 1))
        end
        return num
    end

    local function consumeIdentifier()
        skip_spaces()
        local start = cursor
        while expression:sub(cursor, cursor):match("%a") do advance() end
        return expression:sub(start, cursor - 1)
    end

    local function factorial(n)
        if n < 0 then
            fail(Error.FACTORIAL_NEGATIVE, n)
        end
        if n ~= math.floor(n) then
            fail(Error.FACTORIAL_NON_INTEGER, n)
        end
        local result = 1
        for i = 2, n do
            result = result * i
        end
        return result
    end

    local parse

    local function parseAtom()
        local character = next_character()
        if character == "(" then
            advance()
            local value = parse()
            skip_spaces()
            if next_character() ~= ")" then
                fail(Error.EXPECTED_CLOSING_PAREN)
            end
            advance()
            return value
        elseif character == "" then
            fail(Error.UNEXPECTED_END)
        elseif character:match("%a") then
            local name = consumeIdentifier()
            local fn = functions[name]
            if next_character() == "(" then
                if not fn then
                    fail(Error.UNKNOWN_FUNCTION, name)
                end
                advance()
                local argument = parse()
                skip_spaces()
                if next_character() ~= ")" then
                    fail(Error.EXPECTED_CLOSING_PAREN)
                end
                advance()
                return fn(argument)
            end
            local value = constants[name]
            if value == nil then
                if fn then
                    fail(Error.EXPECTED_OPENING_PAREN, name)
                end
                fail(Error.UNKNOWN_IDENTIFIER, name)
            end
            return value
        else
            return consumeNumber()
        end
    end

    local parseFactor

    local function parsePostfix()
        local value = parseAtom()
        -- Only a single "!" is allowed
        if next_character() == "!" then
            advance()
            value = factorial(value)
        end
        return value
    end

    local function parsePower()
        local base = parsePostfix()
        if next_characters(2) == "**" then
            advance(2)
            return base ^ parseFactor()
        elseif next_character() == "^" then
            advance()
            return base ^ parseFactor()
        end
        return base
    end


    parseFactor = function()
        if next_character() == "-" then
            advance()
            return -parseFactor()
        elseif next_character() == "+" then
            advance()
            return parseFactor()
        end
        return parsePower()
    end

    local function parseTerm()
        local value = parseFactor()
        while true do
            local character = next_character()
            if character == "*" then
                advance()
                value = value * parseFactor()
            elseif character == "/" then
                advance()
                local divisor = parseFactor()
                if divisor == 0 then
                    fail(Error.DIVISION_BY_ZERO)
                end
                value = value / divisor
            elseif character == "%" then
                advance()
                local divisor = parseFactor()
                if divisor == 0 then
                    fail(Error.MODULO_BY_ZERO)
                end
                value = value % divisor
            else
                break
            end
        end
        return value
    end

    parse = function()
        local value = parseTerm()
        while true do
            local character = next_character()
            if character == "+" then
                advance()
                value = value + parseTerm()
            elseif character == "-" then
                advance()
                value = value - parseTerm()
            else
                break
            end
        end
        return value
    end

    local result = parse()
    skip_spaces()
    if cursor <= expression:len() then
        fail(Error.UNEXPECTED_TRAILING_INPUT, expression:sub(cursor, expression:len()))
    end
    return result
end

return Calculator

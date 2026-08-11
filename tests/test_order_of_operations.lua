package.path = "tests/lib/luaunit/?.lua;" .. package.path
local luaunit = require("luaunit")

package.path = "?.lua;" .. package.path
local Calculator = require "calculator"

local parse = Calculator.parseExpression

-- Brackets / Parentheses
TestBrackets = {}

function TestBrackets:testParensBeatMultiplication()
    luaunit.assertEquals(parse("(2+3)*4"), 20)
end

function TestBrackets:testParensBeatExponent()
    luaunit.assertEquals(parse("(2+3)^2"), 25)
end

function TestBrackets:testParensOnBothSides()
    luaunit.assertEquals(parse("(10-2)/(2+2)"), 2)
end

function TestBrackets:testNestedParens()
    luaunit.assertEquals(parse("((1+2)*(3+4))"), 21)
end

-- Absolute value bars act like brackets
TestAbsoluteValueGrouping = {}

function TestAbsoluteValueGrouping:testActsLikeBrackets()
    luaunit.assertEquals(parse("|2-5|*2"), 6)
end

function TestAbsoluteValueGrouping:testBindsTighterThanExponent()
    luaunit.assertEquals(parse("|-2|^2"), 4)
end

function TestAbsoluteValueGrouping:testInAddition()
    luaunit.assertEquals(parse("2+|-3|"), 5)
end

-- Orders / Exponents
TestExponents = {}

function TestExponents:testExponentBeforeMultiplication()
    luaunit.assertEquals(parse("2*3^2"), 18)
end

function TestExponents:testExponentBeforeDivision()
    luaunit.assertEquals(parse("12/2^2"), 3)
end

function TestExponents:testExponentBeforeAddition()
    luaunit.assertEquals(parse("1+2^3"), 9)
end

function TestExponents:testExponentIsRightAssociative()
    luaunit.assertEquals(parse("2^3^2"), 512)
end

function TestExponents:testUnaryMinusLooserThanExponent()
    luaunit.assertEquals(parse("-2^2"), -4)
end

function TestExponents:testParensForNegativeBase()
    luaunit.assertEquals(parse("(-2)^2"), 4)
end

function TestExponents:testDoubleStarSamePrecedence()
    luaunit.assertEquals(parse("2*3**2"), 18)
end

function TestExponents:testFactorialInExponent()
    luaunit.assertEquals(parse("2^3!"), 64)
end

-- Factorial
TestFactorial = {}

function TestFactorial:testTighterThanExponent()
    luaunit.assertEquals(parse("3!^2"), 36)
end

function TestFactorial:testTighterThanMultiplication()
    luaunit.assertEquals(parse("2*4!"), 48)
end

function TestFactorial:testTighterThanUnaryMinus()
    luaunit.assertEquals(parse("-3!"), -6)
end

function TestFactorial:testTighterThanAddition()
    luaunit.assertEquals(parse("2+3!"), 8)
end

-- Multiplication, Division and Modulo
TestMultiplicationAndDivision = {}

function TestMultiplicationAndDivision:testOverAddition()
    luaunit.assertEquals(parse("2+3*4"), 14)
end

function TestMultiplicationAndDivision:testOverSubtraction()
    luaunit.assertEquals(parse("20-5*2"), 10)
end

function TestMultiplicationAndDivision:testDivisionLeftToRight()
    luaunit.assertEquals(parse("8/4/2"), 1)
end

function TestMultiplicationAndDivision:testMixedLeftToRight()
    luaunit.assertEquals(parse("6/2*3"), 9)
end

function TestMultiplicationAndDivision:testViralDivisionParens()
    luaunit.assertEquals(parse("6/2*(1+2)"), 9)
end

function TestMultiplicationAndDivision:testModuloSameLevelLeftToRight()
    luaunit.assertEquals(parse("2*10%3"), 2)
end

function TestMultiplicationAndDivision:testModuloBeforeAddition()
    luaunit.assertEquals(parse("2+10%3"), 3)
end

function TestMultiplicationAndDivision:testDivisionAndModuloLeftToRight()
    luaunit.assertEquals(parse("10/2%3"), 2)
end

-- Addition and Subtraction
TestAdditionAndSubtraction = {}

function TestAdditionAndSubtraction:testSubtractionLeftToRight()
    luaunit.assertEquals(parse("10-3-2"), 5)
end

function TestAdditionAndSubtraction:testMixedLeftToRight()
    luaunit.assertEquals(parse("10-3+2"), 9)
end

function TestAdditionAndSubtraction:testChain()
    luaunit.assertEquals(parse("1+2-3+4"), 4)
end

-- Full expressions
TestMixedPrecedence = {}

function TestMixedPrecedence:testAllFourOperators()
    luaunit.assertEquals(parse("2+3*4-6/2"), 11)
end

function TestMixedPrecedence:testExponentThenMultiplyThenAdd()
    luaunit.assertEquals(parse("2*3^2+1"), 19)
end

function TestMixedPrecedence:testParensExponentMultiply()
    luaunit.assertEquals(parse("(1+2)^2*3"), 27)
end

function TestMixedPrecedence:testExponentDivideThenSubtract()
    luaunit.assertEquals(parse("10-2^3/4"), 8)
end

function TestMixedPrecedence:testEverything()
    luaunit.assertEquals(parse("2^3+4*5-6/2"), 25)
end

function TestMixedPrecedence:testParensAndExponent()
    luaunit.assertEquals(parse("(2+3)*(4-1)^2"), 45)
end

os.exit(luaunit.LuaUnit.run())

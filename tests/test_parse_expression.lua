package.path = "tests/lib/luaunit/?.lua;" .. package.path
local luaunit = require("luaunit")

package.path = "?.lua;" .. package.path
local Calculator = require "calculator"

local parse = Calculator.parseExpression

-- Binary operators: + - * / %
TestBinaryOperators = {}

function TestBinaryOperators:testAddition()
    luaunit.assertEquals(parse("2+3"), 5)
end

function TestBinaryOperators:testSubtraction()
    luaunit.assertEquals(parse("10-4"), 6)
end

function TestBinaryOperators:testMultiplication()
    luaunit.assertEquals(parse("6*7"), 42)
end

function TestBinaryOperators:testDivision()
    luaunit.assertEquals(parse("20/4"), 5)
end

function TestBinaryOperators:testFloatResult()
    luaunit.assertAlmostEquals(parse("7/2"), 3.5, 0.0001)
end

function TestBinaryOperators:testModulo()
    luaunit.assertEquals(parse("10%3"), 1)
end

function TestBinaryOperators:testNegativeModulo()
    luaunit.assertEquals(parse("-10%3"), 2)
end

function TestBinaryOperators:testModuloWithFloatOperand()
    luaunit.assertAlmostEquals(parse("10.5%3"), 1.5, 0.0001)
end

-- Exponent: ^ and **
TestExponent = {}

function TestExponent:testExponent()
    luaunit.assertEquals(parse("2^10"), 1024)
end

function TestExponent:testDoubleStarExponentAlias()
    luaunit.assertEquals(parse("2**3"), 8)
end

function TestExponent:testIsRightAssociative()
    luaunit.assertEquals(parse("2^3^2"), 512)
end

function TestExponent:testDoubleStarWithNegativeExponent()
    luaunit.assertEquals(parse("2**-3"), 0.125)
end

function TestExponent:testWithNegativeOperand()
    luaunit.assertEquals(parse("2^-2"), 0.25)
end

function TestExponent:testFactorialWithDoubleStarAlias()
    luaunit.assertEquals(parse("3!**2"), 36)
end

-- Factorial
TestFactorial = {}

function TestFactorial:testFactorial()
    luaunit.assertEquals(parse("5!"), 120)
end

function TestFactorial:testFactorialOfZero()
    luaunit.assertEquals(parse("0!"), 1)
end

function TestFactorial:testFactorialOfOne()
    luaunit.assertEquals(parse("1!"), 1)
end

function TestFactorial:testFactorialAfterParens()
    luaunit.assertEquals(parse("(3+2)!"), 120)
end

function TestFactorial:testNestedFactorialAndExponent()
    luaunit.assertEquals(parse("3!^2"), 36)
end

-- Unary plus and minus
TestUnaryOperators = {}

function TestUnaryOperators:testNegativeNumbers()
    luaunit.assertEquals(parse("-5+3"), -2)
end

function TestUnaryOperators:testDoubleUnaryMinus()
    luaunit.assertEquals(parse("--5"), 5)
end

function TestUnaryOperators:testUnaryMinusOnFactorial()
    luaunit.assertEquals(parse("-3!"), -6)
end

function TestUnaryOperators:testChainedUnaryMinusWithFactorial()
    luaunit.assertEquals(parse("--3!"), 6)
end

function TestUnaryOperators:testUnaryMinusBeforeExponent()
    luaunit.assertEquals(parse("-2^2"), -4)
end

function TestUnaryOperators:testUnaryMinusOnParenExpression()
    luaunit.assertEquals(parse("-(2+3)"), -5)
end

function TestUnaryOperators:testParenNegativeThenExponent()
    luaunit.assertEquals(parse("(-2)^2"), 4)
end

function TestUnaryOperators:testUnaryMinusMultiplication()
    luaunit.assertEquals(parse("-2*-3"), 6)
end

function TestUnaryOperators:testUnaryMinusAtStartOfParenGroup()
    luaunit.assertEquals(parse("3*(-2+1)"), -3)
end

function TestUnaryOperators:testUnaryPlus()
    luaunit.assertEquals(parse("+3"), 3)
end

function TestUnaryOperators:testUnaryPlusBeforeExponent()
    luaunit.assertEquals(parse("+2^2"), 4)
end

function TestUnaryOperators:testUnaryPlusOnFactorial()
    luaunit.assertEquals(parse("+3!"), 6)
end

function TestUnaryOperators:testDoubleUnaryPlus()
    luaunit.assertEquals(parse("++5"), 5)
end

function TestUnaryOperators:testMixedUnaryPlusMinus()
    luaunit.assertEquals(parse("+-5"), -5)
end

function TestUnaryOperators:testMixedUnaryMinusPlus()
    luaunit.assertEquals(parse("-+5"), -5)
end

-- Precedence and parentheses grouping
TestPrecedenceAndParens = {}

function TestPrecedenceAndParens:testOperatorPrecedence()
    luaunit.assertEquals(parse("2+3*4"), 14)
end

function TestPrecedenceAndParens:testParentheses()
    luaunit.assertEquals(parse("(2+3)*4"), 20)
end

function TestPrecedenceAndParens:testNestedParens()
    luaunit.assertEquals(parse("((2+3)*(4-1))"), 15)
end

-- Number literals
TestNumberLiterals = {}

function TestNumberLiterals:testLeadingDecimalPoint()
    luaunit.assertEquals(parse(".5+.5"), 1)
end

function TestNumberLiterals:testTrailingDecimalPoint()
    luaunit.assertEquals(parse("5.+2"), 7)
end

-- Whitespace
TestWhitespace = {}

function TestWhitespace:testWhitespaceEverywhere()
    luaunit.assertEquals(parse("  2 + 3 * ( 4 - 1 )  "), 11)
end

function TestWhitespace:testWhitespaceAroundUnaryMinus()
    luaunit.assertEquals(parse("- 5 + 3"), -2)
end

function TestWhitespace:testUnaryPlusWithSpaces()
    luaunit.assertEquals(parse("+ 5 + 3"), 8)
end

-- Malformed input and errors
TestErrors = {}

function TestErrors:testDivisionByZero()
    luaunit.assertError(parse, "5/0")
end

function TestErrors:testModuloDivisionByZero()
    luaunit.assertError(parse, "5/0")
end

function TestErrors:testMalformedExpression()
    luaunit.assertError(parse, "2++")
end

function TestErrors:testEmptyString()
    luaunit.assertError(parse, "")
end

function TestErrors:testFactorialOfNegative()
    luaunit.assertError(parse, "(-3)!")
end

function TestErrors:testFactorialOfNonInteger()
    luaunit.assertError(parse, "2.5!")
end

function TestErrors:testDoubleFactorial()
    luaunit.assertError(parse, "3!!")
end

function TestErrors:testMalformedNumberMultipleDots()
    luaunit.assertError(parse, "1.2.3")
end

function TestErrors:testUnmatchedOpeningParen()
    luaunit.assertError(parse, "(2+3")
end

function TestErrors:testMismatchedClosingParen()
    luaunit.assertError(parse, "2+3)")
end

function TestErrors:testEmptyParens()
    luaunit.assertError(parse, "()")
end

function TestErrors:testInvalidCharacter()
    luaunit.assertError(parse, "2+a")
end

function TestErrors:testParenWithNoOperator()
    luaunit.assertError(parse, "2(3+1)")
end

function TestErrors:testImplicitConcatenation()
    luaunit.assertError(parse, "2 3")
end

os.exit(luaunit.LuaUnit.run())

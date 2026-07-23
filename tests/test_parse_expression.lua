package.path = "lib/luaunit/?.lua;" .. package.path
local luaunit = require("luaunit")

package.path = "../?.lua;" .. package.path
local Calculator = require "calculator"

-- Successes

function testAddition()
    luaunit.assertEquals(Calculator.parseExpression("2+3"), 5)
end

function testSubtraction()
    luaunit.assertEquals(Calculator.parseExpression("10-4"), 6)
end

function testMultiplication()
    luaunit.assertEquals(Calculator.parseExpression("6*7"), 42)
end

function testDivision()
    luaunit.assertEquals(Calculator.parseExpression("20/4"), 5)
end

function testExponent()
    luaunit.assertEquals(Calculator.parseExpression("2^10"), 1024)
end

function testModulo()
    luaunit.assertEquals(Calculator.parseExpression("10%3"), 1)
end

function testFactorial()
    luaunit.assertEquals(Calculator.parseExpression("5!"), 120)
end

function testOperatorPrecedence()
    luaunit.assertEquals(Calculator.parseExpression("2+3*4"), 14)
end

function testParentheses()
    luaunit.assertEquals(Calculator.parseExpression("(2+3)*4"), 20)
end

function testNestedFactorialAndExponent()
    luaunit.assertEquals(Calculator.parseExpression("3!^2"), 36)
end

function testFloatResult()
    luaunit.assertAlmostEquals(Calculator.parseExpression("7/2"), 3.5, 0.0001)
end

function testNegativeNumbers()
    luaunit.assertEquals(Calculator.parseExpression("-5+3"), -2)
end

function testDoubleStarExponentAlias()
    luaunit.assertEquals(Calculator.parseExpression("2**3"), 8)
end

function testDoubleStarWithNegativeExponent()
    luaunit.assertEquals(Calculator.parseExpression("2**-3"), 0.125)
end

function testExponentIsRightAssociative()
    luaunit.assertEquals(Calculator.parseExpression("2^3^2"), 512)
end

function testFactorialWithDoubleStarAlias()
    luaunit.assertEquals(Calculator.parseExpression("3!**2"), 36)
end

function testWhitespaceEverywhere()
    luaunit.assertEquals(Calculator.parseExpression("  2 + 3 * ( 4 - 1 )  "), 11)
end

function testWhitespaceAroundUnaryMinus()
    luaunit.assertEquals(Calculator.parseExpression("- 5 + 3"), -2)
end

function testLeadingDecimalPoint()
    luaunit.assertEquals(Calculator.parseExpression(".5+.5"), 1)
end

function testTrailingDecimalPoint()
    luaunit.assertEquals(Calculator.parseExpression("5.+2"), 7)
end

function testMalformedNumberMultipleDotsThrows()
    luaunit.assertError(Calculator.parseExpression, "1.2.3")
end

function testFactorialOfZero()
    luaunit.assertEquals(Calculator.parseExpression("0!"), 1)
end

function testFactorialOfOne()
    luaunit.assertEquals(Calculator.parseExpression("1!"), 1)
end

function testFactorialAfterParens()
    luaunit.assertEquals(Calculator.parseExpression("(3+2)!"), 120)
end

function testDoubleFactorialThrows()
    luaunit.assertError(Calculator.parseExpression, "3!!")
end

function testChainedUnaryMinusWithFactorial()
    luaunit.assertEquals(Calculator.parseExpression("--3!"), 6)
end

function testNegativeModulo()
    luaunit.assertEquals(Calculator.parseExpression("-10%3"), 2)
end

function testModuloWithFloatOperand()
    luaunit.assertAlmostEquals(Calculator.parseExpression("10.5%3"), 1.5, 0.0001)
end

function testUnaryPlus()
    luaunit.assertEquals(Calculator.parseExpression("+3"), 3)
end

function testUnaryPlusBeforeExponent()
    luaunit.assertEquals(Calculator.parseExpression("+2^2"), 4)
end

function testUnaryPlusOnFactorial()
    luaunit.assertEquals(Calculator.parseExpression("+3!"), 6)
end

function testDoubleUnaryPlus()
    luaunit.assertEquals(Calculator.parseExpression("++5"), 5)
end

function testMixedUnaryPlusMinus()
    luaunit.assertEquals(Calculator.parseExpression("+-5"), -5)
end

function testMixedUnaryMinusPlus()
    luaunit.assertEquals(Calculator.parseExpression("-+5"), -5)
end

function testUnaryPlusWithSpaces()
    luaunit.assertEquals(Calculator.parseExpression("+ 5 + 3"), 8)
end

-- Errors

function testDivisionByZeroThrows()
    luaunit.assertError(Calculator.parseExpression, "5/0")
end

function testMalformedExpressionThrows()
    luaunit.assertError(Calculator.parseExpression, "2++")
end

function testEmptyStringThrows()
    luaunit.assertError(Calculator.parseExpression, "")
end

function testFactorialOfNegativeThrows()
    luaunit.assertError(Calculator.parseExpression, "(-3)!")
end

function testFactorialOfNonIntegerThrows()
    luaunit.assertError(Calculator.parseExpression, "2.5!")
end

function testUnmatchedParenThrows()
    luaunit.assertError(Calculator.parseExpression, "(2+3")
end

function testInvalidCharacterThrows()
    luaunit.assertError(Calculator.parseExpression, "2+a")
end

function testUnaryMinusBeforeExponent()
    luaunit.assertEquals(Calculator.parseExpression("-2^2"), -4)
end

function testUnaryMinusOnParenExpression()
    luaunit.assertEquals(Calculator.parseExpression("-(2+3)"), -5)
end

function testParenNegativeThenExponent()
    luaunit.assertEquals(Calculator.parseExpression("(-2)^2"), 4)
end

function testExponentWithNegativeOperand()
    luaunit.assertEquals(Calculator.parseExpression("2^-2"), 0.25)
end

function testDoubleUnaryMinus()
    luaunit.assertEquals(Calculator.parseExpression("--5"), 5)
end

function testUnaryMinusOnFactorial()
    luaunit.assertEquals(Calculator.parseExpression("-3!"), -6)
end

function testUnaryMinusInsideParenWithFactorial()
    luaunit.assertError(Calculator.parseExpression, "(-3)!")
end

function testNestedParens()
    luaunit.assertEquals(Calculator.parseExpression("((2+3)*(4-1))"), 15)
end

function testUnaryMinusAtStartOfParenGroup()
    luaunit.assertEquals(Calculator.parseExpression("3*(-2+1)"), -3)
end

function testUnaryMinusMultiplication()
    luaunit.assertEquals(Calculator.parseExpression("-2*-3"), 6)
end

function testEmptyParensThrows()
    luaunit.assertError(Calculator.parseExpression, "()")
end

function testMismatchedClosingParenThrows()
    luaunit.assertError(Calculator.parseExpression, "2+3)")
end

function testParenWithNoOperatorThrows()
    luaunit.assertError(Calculator.parseExpression, "2(3+1)")
end

function testImplicitConcatenationThrows()
    luaunit.assertError(Calculator.parseExpression, "2 3")
end

os.exit(luaunit.LuaUnit.run())

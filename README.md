
![Latest Version](https://img.shields.io/factorio-mod-portal/v/quick-calculator) ![Last Updated](https://img.shields.io/factorio-mod-portal/last-updated/quick-calculator) ![Downloads](https://img.shields.io/factorio-mod-portal/dt/quick-calculator)
![License](https://img.shields.io/github/license/dmytro-dovg/quick-calculator)

# Quick Calculator

A pop-up calculator for Factorio. Quick math without leaving the game.

![Demo](docs/demo2.gif)

## Usage

Press `Ctrl + Alt + C` or run `/qcalc` to open the calculator, then type an expression. The result updates as you type. Press `Enter` or `Escape` to close.

You can also pass an expression straight to `/qcalc` to print the result without opening the window:

```
/qcalc 3 + 12/4
```

## Supported syntax

### Numbers

| Form | Example |
|------|---------|
| Decimal | `42`, `3.14`, `.5` |
| Hex / binary / octal | `0xFF = 255`, `0b1010 = 10`, `0o17 = 15` |
| Scientific notation | `2e3 = 2000`, `1.5e-4 = 0.00015` |
| SI suffix | `10k = 10000`, `2.5M = 2500000` |

SI suffixes are `k` `M` `G` `T` `P` (10^3 through 10^15).

### Operators

| Operator | Description | Example |
|----------|---------|---------|
| `+` `-` `*` `/` | add, subtract, multiply, divide | `2 + 3 * 4 = 14` |
| `%` | modulo (remainder) | `10 % 3 = 1` |
| `^` `**` | exponent or power | `2 ^ 10 = 1024`, `2 ** 3 = 8` |
| `!` | factorial | `5! = 120` |
| `-x` `+x` | unary sign | `-3`, `+3` |
| `( )` | grouping | `(2 + 3) * 4 = 20` |
| `\| \|` | absolute value | `\|-7\| = 7` |

### Functions

Called as `name(x)`, e.g. `sqrt(2 + 7)`.

| Function | Description | Example |
|----------|---------|---------|
| `sqrt` | square root | `sqrt(9) = 3` |
| `abs` | absolute value | `abs(-7) = 7` |
| `exp` | e to the power x | `exp(1) = 2.71828...` |
| `ln` | natural logarithm | `ln(e) = 1` |
| `log` | base-10 logarithm | `log(1000) = 3` |
| `log2` | base-2 logarithm | `log2(8) = 3` |
| `sin` `cos` `tan` | trigonometry (radians) | `cos(0) = 1` |
| `asin` `acos` `atan` | inverse trigonometry (radians) | `acos(1) = 0` |
| `rad` | degrees to radians | `rad(180) = 3.14159...` |
| `deg` | radians to degrees | `deg(pi) = 180` |
| `floor` | round down | `floor(3.9) = 3` |
| `ceil` | round up | `ceil(3.1) = 4` |
| `round` | round to nearest | `round(2.5) = 3` |
| `trunc` | round toward zero | `trunc(-3.9) = -3` |
| `sign` | sign (-1, 0, or 1) | `sign(-42) = -1` |

### Constants

| Constant | Value |
|----------|-------|
| [pi](https://en.wikipedia.org/wiki/Pi) | `3.14159...` |
| [e](https://en.wikipedia.org/wiki/E_(mathematical_constant)) | `2.71828...` |

## License

[MIT](LICENSE)

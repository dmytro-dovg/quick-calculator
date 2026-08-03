
![Lastest Version](https://img.shields.io/factorio-mod-portal/v/quick-calculator) ![Last Updated](https://img.shields.io/factorio-mod-portal/last-updated/quick-calculator) ![Downloads](https://img.shields.io/factorio-mod-portal/dt/quick-calculator)
![License](https://img.shields.io/github/license/dmytro-dovg/quick-calculator)

# Quick Calculator

A pop-up calculator for Factorio. Do quick math without leaving the game.

![Demo](docs/demo2.gif)

## Usage

Press `Ctrl + Alt + C` or run `/qcalc` to open the calculator. As you type an expression, the result updates live. Press `Enter` or `Escape` to close the window.

To evaluate an expression without opening the window, pass it to `/qcalc` directly and the result will be printed on the screen:

```
/qcalc 3 + 12/4
```

## Supported syntax

| Category | Operators / names |
|----------|-------------------|
| Arithmetic | `+` `-` `*` `/` |
| Modulo | `%` |
| Exponent | `^` or `**` |
| Factorial | `!` (single) |
| Unary signs | `-x`, `+x` |
| Grouping | `( )` |
| Functions | `sqrt` `abs` `exp` `ln` `log` `log2` `sin` `cos` `tan` `asin` `acos` `atan` `floor` `ceil` `round` `trunc` `sign` `rad` `deg` |
| Constants | `pi` `e` |

> Trigonometric functions use radians.

## License

[MIT](LICENSE)

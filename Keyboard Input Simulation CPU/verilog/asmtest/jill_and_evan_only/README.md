# Factorials in Assembly

This test calculates the factorial of the signed integer stored in `$a0` and stores it in `$v0`.

In pseudo-RTL: `R[$v0] = R[$a0]!`

A definition of factorial [from Wikipedia](https://en.wikipedia.org/wiki/Factorial):
> The factorial of a positive integer _n_, denoted by _n_!, is the product of all positive integers less than of equal to _n_:  
> _n_! _= n * (n-1) * (n-2) * (n-3) * ... * 3 * 2 * 1_

Note that 0! is 1.

Additionally, **`$a0` should be any positive integer between 0 and 12, inclusive** (the factorial function is not defined for negative integers, and `13! = 6227020800`, larger than the maximum 32-bit signed integer `6227020800`, so **any `$a0` values greater than 12 will result in an overflow**).

## Example Expected Results:
| `$a0` | `$v0` |
|-------|-------|
| `d0`  | `d1`  |
| `d1`  | `d1`  |
| `d2`  | `d2`  |
| `d3`  | `d6`  |
| `d4`  | `d24` |
| `d12` | `d479001600` |

## Instructions Used
No additional instructions beyond the lab requirements need to be implemented. Specifically, the following instructions are used by this test case: 

- `add`
- `addi`
- `j`
- `beq`

# `forge coverage --force-via-ir` false-positive reproducer

This is a tiny Foundry project that demonstrates why `forge coverage` disables
the optimizer / via-IR by default and what goes wrong if you opt back in via
`--force-via-ir`.

## Setup

```sh
cd port-tests/viair-coverage-fp
forge install --no-git foundry-rs/forge-std
```

## Reproduce

### LICM-induced false positive (the headline case)

`src/Patterns.sol` contains a function whose loop body has a loop-invariant
subexpression (`base * 7 + 13`). The test feeds in an empty array, so the
loop body must not execute.

```sh
# Baseline: optimizer + via-IR disabled, source maps are accurate.
forge coverage --report lcov --report-file baseline.lcov
grep '^DA:' baseline.lcov

# Forced via-IR: optimizer hoists `base*7+13` out of the loop, the hoisted
# PC keeps the loop body's source position, coverage marks the loop body
# as hit.
forge coverage --force-via-ir --report lcov --report-file viair.lcov
grep '^DA:' viair.lcov
```

Expected on the loop body line:

| line | content                              | baseline | --force-via-ir   |
| ---- | ------------------------------------ | -------- | ---------------- |
| 15   | `r += arr[i] + base * 7 + 13;`       | DA:15,0  | DA:15,1  ← **FP** |

### Function-dedup case (weaker)

`src/Demo.sol` has two byte-identical `internal` helpers. Yul's
`EquivalentFunctionCombiner` merges them; the surviving bytecode's source
map points at `addA` only.

```sh
forge coverage --force-via-ir --report lcov
# Test calls useB → coverage reports addA / useA as hit
```

This one is more debatable as a "real" FP because the merged helpers are
byte-equivalent. The Patterns.sol case is the cleaner demonstration — the
loop body line is reported hit even though arr is empty.

## Notes

- `--force-via-ir` is mutually exclusive with `--ir-minimum`.
- The flag emits a runtime warning explaining the trade-off.
- The same false-positive pattern (LICM hoisting an invariant) is very
  common in real code: any loop over `arr` / `validators` / `pendingRewards`
  with an outside-loop-invariant operand has this shape.

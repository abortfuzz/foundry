// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// Demonstrates a *line coverage false positive* under `forge coverage
/// --force-via-ir`: a line that is never executed at runtime is reported as
/// hit. Caused by the Yul optimizer hoisting loop-invariant subexpressions
/// out of the loop while leaving the hoisted PC's source position pointing
/// at the original (intra-loop) line.
contract Patterns {
    uint256 public sink;

    function p4_loop(uint256[] memory arr, uint256 base) external returns (uint256) {
        uint256 r = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            r += arr[i] + base * 7 + 13;   // loop-invariant `base*7+13` gets hoisted
        }
        sink = r;
        return r;
    }
}

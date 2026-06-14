// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// A weaker FP demonstration: two structurally identical `internal` helpers
/// merged by Yul `EquivalentFunctionCombiner`. After merging, the surviving
/// bytecode's source map points only at `addA`, so calling `useB` reports
/// `addA` / `useA` as covered. Whether this counts as a "real" FP is
/// debatable since the merged functions are byte-equivalent — kept here as
/// a curiosity, not as the headline case (see Patterns.sol for that).
contract Demo {
    uint256 public total;

    function addA(uint256 x) internal pure returns (uint256) {
        uint256 r = x + 1;
        return r * 2;
    }

    function addB(uint256 x) internal pure returns (uint256) {
        uint256 r = x + 1;
        return r * 2;
    }

    function useA(uint256 x) external {
        total = addA(x);
    }

    function useB(uint256 x) external {
        total = addB(x);
    }
}

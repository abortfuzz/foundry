// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import {Patterns} from "../src/Patterns.sol";

contract PatternsTest is Test {
    Patterns p;

    function setUp() public {
        p = new Patterns();
    }

    /// Calls `p4_loop` with an empty array, so the loop body line MUST NOT
    /// execute. Under `--force-via-ir`, line coverage will still report it
    /// as hit (false positive).
    function test_p4_empty_array() public {
        uint256[] memory arr = new uint256[](0);
        p.p4_loop(arr, 100);
    }
}

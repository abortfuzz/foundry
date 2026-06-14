// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import {Demo} from "../src/Demo.sol";

contract DemoTest is Test {
    Demo demo;

    function setUp() public {
        demo = new Demo();
    }

    /// Only `useB` is called. Under `--force-via-ir`, `addA` / `useA` get
    /// reported as covered because the merged function's source map points
    /// only at `addA`.
    function test_only_useB() public {
        demo.useB(10);
        assertEq(demo.total(), 22);
    }
}

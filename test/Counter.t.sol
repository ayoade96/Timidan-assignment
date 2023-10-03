// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testCompact() public {
        bytes32 packed=vm.load(address(counter),bytes32(uint));
        console2.logUint(uint128(uint256(packed)));
        assertEq(uint128(uint256(packed)),137);
        uint128 b;
        uint256 a;
        a=uint128( uint256 (packed << 128) & type(uint256).max)
        b=uint128( uint256 (packed >> 128) & type(uint256).max)
        console2.logUint(a);
        console2.logUInt(b);

    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}

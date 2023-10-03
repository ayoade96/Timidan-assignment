// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ValuePacker {
    function packValues(uint128 value1, uint128 value2) public pure returns (uint256) {
        // Pack two uint128 values into a single uint256 value
        return uint256(value1) << 128 | uint256(value2);
    }

    function unpackValues(uint256 packedValue) public pure returns (uint128, uint128) {
        // Unpack a uint256 value into two uint128 values
        uint128 value1 = uint128(packedValue >> 128);
        uint128 value2 = uint128(packedValue);

        return (value1, value2);
    }
}

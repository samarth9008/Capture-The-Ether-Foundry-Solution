// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/GuessRandomNumber.sol";

contract GuessRandomNumberTest is Test {
    using stdStorage for StdStorage;

    GuessRandomNumber public guessRandomNumber;

    function setUp() public {}

    function testAnswer(uint256 blockNumber, uint256 blockTimestamp) public {
        // Prevent zero inputs
        vm.assume(blockNumber != 0);
        vm.assume(blockTimestamp != 0);
        // Set block number and timestamp
        vm.roll(blockNumber);
        vm.warp(blockTimestamp);

        // Place your solution here
        guessRandomNumber = (new GuessRandomNumber){value: 1 ether}();
        uint256 slotOfAnswer = stdstore
            .target(address(guessRandomNumber))
            .sig("answer()")
            .find();
        uint8 guess = uint8(
            uint(
                vm.load(
                    address(guessRandomNumber), bytes32(abi.encode(slotOfAnswer))
                )
            )
        );
        guessRandomNumber.guess{value: 1 ether}(guess);

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(guessRandomNumber.isComplete(), "Wrong Number");
    }

    receive() external payable {}
}

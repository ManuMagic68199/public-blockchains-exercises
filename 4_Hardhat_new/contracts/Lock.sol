// SPDX-License-Identifier: UNLICENSED
//What is Hardhat? - Environment to test and deploy smart contracts
// How many blcokchains are in hardhat - infinitive
// How do we run hardhat commands? - 
// wht is in the artifacts/ folder? - contains the deployed code of our project
// deploy script - take code von smart contracts and spins it up to the blockchain 
// pupose of hardhat.config.js - you can specify specific networks (goerly uni mannheim usw.)

pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Lock {
    uint public unlockTime;
    address payable public owner;

    event Withdrawal(uint amount, uint when);

    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}

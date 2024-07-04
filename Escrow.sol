// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;
    bool public isApproved;
    uint256 public deadline;

    constructor(address _beneficiary, address _arbiter, uint256 _deadline) payable {
        depositor = msg.sender;
        beneficiary = _beneficiary;
        arbiter = _arbiter;
        deadline = block.timestamp + _deadline;
    }

    function approve() public {
        require(msg.sender == arbiter, "Only arbiter can approve");
        isApproved = true;
        payable(beneficiary).transfer(address(this).balance);
    }

    function refund() public {
        require(msg.sender == arbiter, "Only arbiter can cancel");
        isApproved = false;
        payable(depositor).transfer(address(this).balance);
    }

    function replaceArbiter(address newArbiter) public {
        require(msg.sender == depositor, "Only depositor can replace arbiter");
        arbiter = newArbiter;
    }

    function checkDeadline() public {
        require(block.timestamp >= deadline, "Deadline not reached");
        require(!isApproved, "Already approved");
        payable(depositor).transfer(address(this).balance);
    }
}

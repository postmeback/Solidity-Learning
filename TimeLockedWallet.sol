// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedWallet {
    address public owner;
    uint public unlockTime;

    constructor(address _owner, uint _unlockTime)
    {
        owner = _owner;
        unlockTime = _unlockTime;
    }

    receive() external payable { }  

    function withdraw() external {

        require(block.timestamp >= unlockTime, "Funds are locked");

        require(msg.sender == owner, "Only owners can withdraw");

        payable(owner).transfer(address(this).balance);
    } 

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
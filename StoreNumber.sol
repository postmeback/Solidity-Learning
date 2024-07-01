// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleVoting {
    uint256 public TMC_Count;
    uint256 public BJP_Count;

    mapping (address => bool) public hasVoted;

    event VoteCast(address indexed voter, uint8 _option);

     function vote(uint8 _option) external {
    
    require(_option == 1 || _option == 2, "Invalid option");

    require(!hasVoted[msg.sender], "You have already voted");

    if(_option == 1){
        TMC_Count += 1;
    } else {
        BJP_Count += 1;
    }

    hasVoted[msg.sender] = true;

    emit VoteCast(msg.sender, _option);
    }
}
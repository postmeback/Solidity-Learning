// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address[2] public managers;
    address[] public players;

    constructor() {
        managers[0] = msg.sender; // The contract deployer is the first manager
    }

    function enter() public payable {
        require(msg.value > .01 ether, "Minimum ether required");
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);
        players = new address[](0) ; // Correctly reset the array
    }

    modifier restricted() {
        require(isManager(msg.sender), "Only managers can call this");
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function addManager(address newManager) public restricted {
        require(newManager != address(0), "Invalid address");
        require(!isManager(newManager), "Already a manager");
        
        if (managers[0] == address(0)) {
            managers[0] = newManager;
        } else if (managers[1] == address(0)) {
            managers[1] = newManager;
        } else {
            revert("Cannot add more managers");
        }
    }

    function removeManager(address manager) public restricted {
        require(isManager(manager), "Not a manager");
        require(managers[0] != address(0) || managers[1] != address(0), "There should be at least one manager");
        
        if (managers[0] == manager) {
            managers[0] = address(0);
        } else if (managers[1] == manager) {
            managers[1] = address(0);
        }
    }

    function isManager(address addr) private view returns (bool) {
        return (managers[0] == addr || managers[1] == addr);
    }

    function setSecondManager(address secondManager) public restricted {
        require(managers[1] == address(0), "Second manager already set");
        require(secondManager != address(0), "Invalid address");
        require(secondManager != managers[0], "Cannot set the same address as the first manager");

        managers[1] = secondManager;
    }
}

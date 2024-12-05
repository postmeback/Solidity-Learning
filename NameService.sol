// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract NameService {
    mapping (string => address) public nameToAddress;


    function isNameAvailable(string memory name) public view returns (bool){
        return nameToAddress[name] == address(0);
    }

    function registerName(string memory name) public {
        require(isNameAvailable(name), "Name already taken");
        nameToAddress[name] = msg.sender;
    }

    function resolveName(string memory name) public view returns (address) {
        return nameToAddress[name];
    }
    
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    string public name = "Poddarr"; // Token name
    string public symbol = "Pd"; // Token symbol
    uint8 public decimals = 10; // Token decimals
    uint public totalSupply; // Total supply of tokens

    // Mapping from address to balance
    mapping(address => uint) public balanceOf;
    // Mapping from owner to spender to allowance
    mapping(address => mapping(address => uint)) public allowance;

    // Events to track transfers and approvals
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    // Constructor to initialize the total supply
    constructor(uint _initialSupply) {
        totalSupply = _initialSupply * (10 ** uint(decimals)); // Adjusting for decimals
        balanceOf[msg.sender] = totalSupply; // Assign all tokens to the deployer's address
    }

    // Transfer function to send tokens
    function transfer(address recipient, uint amount) public returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "ERC20: insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // Approve function to allow a spender to transfer tokens
    function approve(address spender, uint amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // TransferFrom function to allow a spender to transfer tokens on behalf of the owner
    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[sender] >= amount, "ERC20: insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "ERC20: allowance exceeded");

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Function to get the balance of a specific address
    function balanceOfAccount(address account) public view returns (uint) {
        return balanceOf[account];
    }

    // Function to get the allowance of a spender
    function allowancelimit(address owner, address spender) public view returns (uint) {
        return allowance[owner][spender];
    }
}

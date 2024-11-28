// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Inheritance {
    address public owner;
    address public recipient;
    bool public isActive;
    uint256 public startDate;
    uint256 public endDate;

    event RecipientUpdated(address indexed oldRecipient, address indexed newRecipient);
    event FundsReleased(address indexed to, uint256 amount);
    event ContractActivated(uint256 startDate, uint256 endDate);
    event ContractDeactivated();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier isContractActive() {
        require(isActive, "Contract is not active");
        _;
    }

    constructor(uint256 _startDate, uint256 _endDate) payable {
        require(_startDate < _endDate, "Start date must be earlier than end date");
        require(msg.value > 0, "Initial funding is required");

        owner = msg.sender;
        startDate = _startDate;
        endDate = _endDate;
        isActive = true;

        emit ContractActivated(_startDate, _endDate);
    }

    function addOrUpdateRecipient(address _recipient) external onlyOwner isContractActive {
        require(_recipient != address(0), "Invalid recipient address");
        emit RecipientUpdated(recipient, _recipient);
        recipient = _recipient;
    }

    function deactivateContract() external onlyOwner isContractActive {
        isActive = false;
        emit ContractDeactivated();
    }

    function activateContract() external onlyOwner {
        require(address(this).balance > 0, "No funds available to reactivate");
        require(block.timestamp < endDate, "Cannot reactivate after endDate");

        isActive = true;
        emit ContractActivated(startDate, endDate);
    }


    function releaseFunds() external isContractActive {
        require(block.timestamp >= endDate, "End date has not passed yet");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available to release");
        address to = recipient != address(0) ? recipient : owner;
        isActive = false; // Automatically deactivate the contract after releasing funds.
        (bool success, ) = to.call{value: balance}("");
        require(success, "Funds transfer failed");
        emit FundsReleased(to, balance);
    }

    // Fallback function to accept Ether
    receive() external payable {}
}

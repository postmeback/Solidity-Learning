// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleCounter {
    int256 public result = 0;

    event PresentResult(int256 result);

    function calculate(uint256 _option) external {
        require(_option == 1 || _option == 2, "Invalid Option");

        if (_option == 1) {
            result += 1;
        } else {
            result -= 1;
        }

        emit PresentResult(result);
    }
}

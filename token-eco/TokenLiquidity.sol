// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact contact@xezom.io
contract TokenLiquidity is Pausable, Ownable {

    uint256 public holdings;
    address public funder;

    function recieveFunds(address _funder, uint256 _amount) public payable {
        holdings = _amount;
        funder = _funder;
    }
}

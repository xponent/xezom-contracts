// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


interface Xezom {
    function mint(address recipient, uint256 amount) external; 
}

interface LiquidityPool {
    function recieveFunds(address _funder, uint256 _amount) external;
}

/// @custom:security-contact contact@xezom.io
contract TokenExchange is Pausable, Ownable {
    /// TODO: Create mapping to hold token information 
    ///       for possible additional token types.

    event Purchased(uint256 _amount, address _buyer);

    address xezomToken;
    address liquidity;
    uint256 feePercent;

    function setTokenAddress(address _address) public onlyOwner {
        xezomToken = _address;
    }

    function setLiquidityAddress(address _address) public onlyOwner {
        liquidity = _address;
    }

    function buy() public payable whenNotPaused {
        address buyer = msg.sender;
        require(msg.value > 0, "You need crypto for the initial exchange.");
        require(buyer != address(0), "Recipient address error.");
        uint256 amount = msg.value;
        (uint256 fee, uint256 newValue, uint256 tokenValue) = _setValues(amount);
        LiquidityPool(liquidity).recieveFunds(buyer, newValue);
        Xezom(xezomToken).mint(buyer, tokenValue);     
        emit Purchased(amount, buyer);                   
    }

    function setFeePercent(uint256 fee) public onlyOwner {
        feePercent = fee;        
    }

    function _setValues(uint256 _amount) public view returns(uint256, uint256, uint256) {
        uint256 fee = feePercent * _amount / 100;
        uint256 newValue = _amount - fee;
        uint256 tokenValue = newValue / 1e15;
        return(fee, newValue, tokenValue);
    }
}

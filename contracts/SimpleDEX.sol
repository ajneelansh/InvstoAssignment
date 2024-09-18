// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts@4.2.0/token/ERC20/ERC20.sol";

contract SimpleDEX {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint public exchangeRate;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(address _tokenA, address _tokenB, uint _exchangeRate) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        exchangeRate = _exchangeRate;
    }

    function setExchangeRate(uint _newRate) public onlyOwner {
        exchangeRate = _newRate;
    }

    function exchangeTokenAForTokenB(uint amountA) public  {
        require(amountA > 0, "Balance Should be grater than 0");
        require(tokenB.balanceOf(address(this)) >= amountA * exchangeRate, "Not enough tokenB to fulfill the exchange");
        unchecked {
            tokenA.transferFrom(msg.sender, address(this), amountA);
            tokenB.transfer(msg.sender, amountA * exchangeRate);
        }
    }

    function exchangeTokenBForTokenA(uint amountB) public {
        require(amountB > 0, "Amount must be greater than 0");
        require(tokenA.balanceOf(address(this)) >= amountB / exchangeRate, "Not enough tokenA to fulfill the exchange");
        unchecked {
            tokenB.transferFrom(msg.sender, address(this), amountB);
            tokenA.transfer(msg.sender, amountB / exchangeRate);
        }
      
    }

  
}

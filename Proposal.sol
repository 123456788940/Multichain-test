// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MTZ.sol";
contract Dex is Ownable {
    IERC20 public stablecoin;
    IERC20 public MTZ;

    struct deposit {
        uint _amount;
        uint releaseTime;
        bool deposited;
        bool withdrawn;
   
    }

    mapping(address=>deposit) public deposits;
    uint public interestRate=2;
    uint public timechainDuration = 15 days;
    constructor(IERC20 _stablecoin, IERC20 _MTZ){
        stablecoin=IERC20(_stablecoin);
        MTZ=IERC20(_MTZ);

    }

    function deposiT(uint amount) external {
        
        require(amount>0, "this has to be higher than zero");
        require(stablecoin.transferFrom(msg.sender, address(this), amount), "transfer not yet done");

        deposits[msg.sender] = deposit({
            _amount:amount,
            releaseTime : block.timestamp + timechainDuration,
            deposited:true,
            withdrawn: false
        });
    }


function withdraw(uint Amount) external {
     deposit storage _deposit= deposits[msg.sender];
    require(Amount>0, "amount must be greater than zero");
    require(block.timestamp>=_deposit.releaseTime, "funds are locked");
    require(_deposit.deposited, "deposit already made");
    require(!_deposit.withdrawn, "withdraw not made yet");

    uint principalAmount=_deposit._amount;
    uint interestAmount=(principalAmount * interestRate) / 100;
    uint totalAmount = principalAmount + interestAmount;
 
     MTZ.transfer(msg.sender, totalAmount);
        _deposit.withdrawn=true;




}




}

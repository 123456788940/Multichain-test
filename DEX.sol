// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Dex{
    // state variable to declare owner
    address owner;
    // bool variable to lock functions
    bool private locked;
    

    // Define the struct for a state order
    struct tradeOrder {
        address trader;
        uint amount;

    }

    modifier onlyOwner(){
        require(owner==msg.sender, "only owner allowed");
        _;
    }
    modifier noReentrancy(){
        require(!locked, "Reentrant call");
        locked=true;
        _;
        locked=false;
    }

    constructor(){
        owner=msg.sender;
    }

    // Define available tokens and balances
    mapping(address=>uint) public tokenBalances;
    //define an escrow to hold during a trade
    mapping(bytes32=>tradeOrder) public escrow;
    // Event to log successful trades
    event tradeExecuted(address indexed buyer, address indexed seller, uint amount);

   // function to create trade Order and initiate the escrow
   function _escrow(bytes32 orderId, address token, uint amount) external onlyOwner noReentrancy{
       require(tokenBalances[token]>=amount,"insufficient balance");
       // transfer the token to the escrow
       tokenBalances[token]-=amount;
       escrow[orderId]=tradeOrder(msg.sender, amount);

   }

   // function to settle a trade and transfer assets
   function _SettleTrade(bytes32 orderId, address token) external onlyOwner noReentrancy{
       tradeOrder storage order = escrow[orderId];
       require(order.trader != address(0), "address not found");
       require(order.trader != msg.sender, "address not found");
       //execute the trade
       uint amount = order.amount;
       address buyer = msg.sender;
       address seller = order.trader;
       // transfer the token from buyer to seller
       tokenBalances[token]+=amount;
       escrow[orderId]=tradeOrder(address(0), 0); // clear the escrow
       emit tradeExecuted(buyer, seller, amount);  
   } 

   // function to withdraw tokens from the Dex
   function withdraw(address payable token, uint amount) external onlyOwner noReentrancy{
       require(tokenBalances[token]>=amount, "balance doesn't suffice");
       require(msg.sender==owner, "only the owner can withdraw");
       // transfer tokens to the owner
       tokenBalances[token]-=amount;
       token.transfer(amount);

   }
}

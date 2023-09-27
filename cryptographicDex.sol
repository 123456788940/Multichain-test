// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NuCypher";

contract cryptographicDex {
    NuCypher private NUCypherContract;



    constructor(address _NuCypherContractAddress) {
        NUCypherContract=NuCypher(_NuCypherContractAddress);
    }

    struct tradeOrder{
        address trader;
        bytes32 encryptedOrder;
      
       
    }
 
    mapping(bytes32=>tradeOrder) public tradeOrders;



    event tradeOrderPlaced(bytes32 indexed ordeId, address indexed trader);


    // place a trade order with encrypted details
    function placeTradeOrder(bytes32 _orderId, bytes32 _encryptedOrder) external {
        NUCypherContract.storeData(_encryptedOrder);
        tradeOrders[_orderId]=tradeOrder(msg.sender, _encryptedOrder);
        emit tradeOrderPlaced(_orderId, msg.sender);
    }
     event tradeOrdershared(bytes32 indexed orderId, address indexed sender, address indexed recipient, bytes32 encryptedOrder);

function shareTradeOrder(bytes32 _orderId, address _recipient) external  {
    tradeOrder memory order=tradeOrders[_orderId];
    require(order.trader != msg.sender, "you do not own this order id");

  bytes32 reencryptedOrder= order.encryptedOrder;
      // Emit an event to notify data sharing
      
        emit tradeOrdershared(_orderId, msg.sender, _recipient, reencryptedOrder);
    }


   
}
    
  
    



   

    




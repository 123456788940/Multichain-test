// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MultiSigAggregator {
    IERC20 public stbl;
   
   struct Transaction{
       address to;
       uint value;
       bytes data;
       bool executed;
       uint confirmationsCount;

   }
   
   
    address[] public owners;
uint public amount;
    uint public requiredConfirmations;
   
 
    mapping(address => bool) public isOwner;
    mapping(bytes32 => uint) public confirmations;
    mapping(bytes32 => Transaction) public transactions;




constructor(address[] memory _owners, uint _requiredConfirmations){
    require(_owners.length>2, "At least 3 owners required");
    require(_requiredConfirmations>1 && _requiredConfirmations <=_owners.length, "Invalid required confirmations");
    for (uint i = 0; i < _owners.length; i++){
        address owner = _owners[i];
        require(owner != address(0), "Invalid owner Address");
        require(!isOwner[owner], "Duplicate owner");
        owners.push(owner);
        isOwner[owner]=true;

    }
    requiredConfirmations = _requiredConfirmations;
}
modifier onlyOwner(){
    require(isOwner[msg.sender], "Not an owner");
    _;
}

// func used to add owner
function addOwner(address newOwner) external onlyOwner {
    require(newOwner !=address(0), "Invalid owner Address");
    require(!isOwner[newOwner], "Already an owner");
    owners.push(newOwner);
    isOwner[newOwner]=true;
  
}

// func used to fire an owner

function removeOwner(address OwnerToRemove) external onlyOwner {
    require(isOwner[OwnerToRemove], "Not an Owner");
    require(!isOwner[OwnerToRemove], "Already an owner");
    require(owners.length>requiredConfirmations, "Cannot remove owner because required confirmations would be violated");
    for(uint i = 0; i < owners.length;i++){
        if(owners[i]==OwnerToRemove){
            owners[i]=owners[owners.length-1];
            owners.pop();
            isOwner[OwnerToRemove]=false;
            
            return;

        }
    }

}

// this func changes the requirement for owners to operate
event requirementChanged(uint requiredConfirmations);
function changeRequirement(uint newRequirementOfConfirmations) external onlyOwner {
    require(newRequirementOfConfirmations>0 && newRequirementOfConfirmations<=owners.length, "Inavalid requiredConfirmations");
    requiredConfirmations = newRequirementOfConfirmations;
    emit  requirementChanged(newRequirementOfConfirmations);
    

}
// function to deposit some amount
event Deposit(address indexed sender, uint amount);
receive() external payable{
    require(msg.value>0, "amount has to be greater than zero");
    emit Deposit(msg.sender, msg.value);
}
// function to withdraw ETH amount
function withdraw(uint _amount) external onlyOwner {
    require(_amount>0, "amount has to be greater than zero");
    require(address(this).balance >= _amount, "insufficient balance");
    payable(msg.sender).transfer(_amount);
}
// before confirmation in order to submit the transaction this func is used
function submitTransaction(address to, uint value, bytes calldata _data) external onlyOwner {
   bytes32 transactionHash = keccak256(abi.encodePacked(to, value, _data, block.number));
   require(transactions[transactionHash].to==address(0), "Transaction already exists");

   transactions[transactionHash]= Transaction({
       to:to,
       value:value,
       data:_data,
       executed:false,
       confirmationsCount:0
   });



}

event TransactionConfirmed(address indexed owner, bytes32 transactionHash);
// this func both confirms and executes the transaction for final time
function transactionConfirmedandExecuted(bytes32 transactionHash) external onlyOwner {
   Transaction storage transaction = transactions[transactionHash];
    require(confirmations[transactionHash] <= requiredConfirmations, "Transaction has already been confirmed by all owners");
    confirmations[transactionHash]++;
     require(!transaction.executed, "execution has already been done");
  require(stbl.transferFrom(address(this), msg.sender, transaction.value), "transfer failed");
  transaction.executed=true;
   
    
    emit TransactionConfirmed(msg.sender, transactionHash);
}



  }






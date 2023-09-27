// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract proposal is Ownable {
    bool private locked;
    IERC20 public multichainZ;


    struct transactOn {
        uint stake;
        bool finalized;
        bool executed;
        bool proposed;
        address proposer;
    }
mapping(bytes32=>transactOn) public transactions;


 modifier noReentrancy(){
        require(!locked, "Reentrant call");
        locked=true;
        _;
        locked=false;
    }

    constructor(IERC20 _multichainZ) {
        multichainZ=IERC20(_multichainZ);

    }

    function propseTransaction(uint amount, bytes32 transactionId) external onlyOwner noReentrancy{
      transactOn storage transaction = transactions[transactionId];
      require(amount>=1000, "amount not correct");
      require(!transaction.proposed, "proposal not done");
      transaction.proposed=true;
      transaction.stake=amount;
      transaction.proposer=msg.sender;

       

    }

    function finalizeProposal(uint amount, bytes32 transactionId) external onlyOwner noReentrancy{
        transactOn storage transaction = transactions[transactionId];
        require(amount>1000, "amount not sufficient");
        require(transaction.proposed, "transaction not proposed");
        require(!transaction.finalized, "finalization not done");
        transaction.finalized=true;


    }
    function ProposalAccepted(uint amount, bytes32 transactionId) external onlyOwner noReentrancy{
        transactOn storage transaction = transactions[transactionId];
        require(amount>1000, "amount not sufficient");
        require(transaction.proposed, "transaction not proposed");
        require(transaction.finalized, "transaction not finalized");
        require(!transaction.executed, "transaction not executed");
        require(multichainZ.transfer(transaction.proposer, transaction.stake), "transaction not sent");
        transaction.executed=true;

    }

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract crowdfunding {
    address public owner;
    uint public fundingGoal;
    uint public deadline;
    bool public goalReached;
    mapping(address => uint) public contributions;
    address[] public contributors;

    constructor(uint _fundingGoalInEther, uint _durationInMinutes) {
        owner = msg.sender;
        fundingGoal = _fundingGoalInEther;
        deadline = block.timestamp + (_durationInMinutes * 1 minutes);
        goalReached = false;

    }

     modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "The deadline has passed");
        _;
    }

    modifier afterDeadline() {
        require(block.timestamp >= deadline, "The deadline has not passed yet");
        _;
    }


    function contribute() public payable beforeDeadline {
        require(msg.value > 0, "value has to be higher than zero");
        contributions[msg.sender] += msg.value;
        contributors.push(msg.sender);
    }

    function checkGoalReached() public afterDeadline {
        if (address(this).balance>= fundingGoal){
            goalReached=true;
        }
    }


    function withdrawFunds() public onlyOwner afterDeadline {
        require(goalReached, "funding goal has not been reached");
        payable(owner).transfer(address(this).balance);

    }

    function refundContributors() public afterDeadline {
        require(!goalReached, "goal has not yet been reached");
        uint contributedAmount = contributions[msg.sender];
        require(contributedAmount>0, "no contribution yet made");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributedAmount);

    }

    function getContributorsCount() public view returns(uint){
        return contributors.length;

    }
}

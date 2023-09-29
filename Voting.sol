// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract votingSytem {
   
    address private voters;
    address private owner;
    
   


    struct votingMachine {
     
        address candidates;
     
        bool voterRegistered;
        bool newVotes;
        bool voted;
      
        bool candidateRegistered;
        bool hasVoted;
    }
    mapping(address=>uint) private votesCount;
   
    mapping(address=>votingMachine) private Voting;

    modifier onlyRegVoters() {
        require(voters==msg.sender, "only voters have access");
        _;

    }

     modifier onlyOwner() {
        require(owner==msg.sender, "only Owner has access");
        _;

    }

    constructor (address _voters, address _owner) {
        owner = _owner;
        voters=_voters;

    }


    function registerVoter(uint voterAboveLegalAge) public onlyRegVoters onlyOwner{
        votingMachine storage voter = Voting[msg.sender];
        require(voterAboveLegalAge>=18, "voter not above legal age");
        require(!voter.voterRegistered, "voter not registered");
   
     voter.voterRegistered=true;

    }

    function regCandidate(uint candidateAboveLegalAge) public onlyRegVoters onlyOwner{
                votingMachine storage candidate = Voting[msg.sender];
                require(candidateAboveLegalAge>=18, "candidate not above legal age");
        require(!candidate.candidateRegistered, "candidate not registered");
       
     candidate.candidateRegistered=true;

    }

    function registerNewVotes() public onlyOwner{
         votingMachine storage voter = Voting[msg.sender];
           require(voter.voterRegistered, "voter registered");
         require(!voter.newVotes, "new votes yet not registered");
         voter.newVotes=true;

        
    }

    function castingVotes(address candidate) public onlyRegVoters onlyOwner{
          votingMachine storage voter = Voting[msg.sender];
             require(voter.voterRegistered, "voter registered");
             require(!voter.voted, "only registered voters can vote");
             require(!voter.hasVoted, "a voter can vote only once");
             
        
             voter.voted=true;
             voter.hasVoted=true;
             votesCount[candidate]++;


    }

    function getVoteCount(address candidate) public returns(uint) {
        
      

        return votesCount[candidate]++;
    }
}

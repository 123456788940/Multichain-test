// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract _Proposal {
    struct Proposal {
        address proposer;
        uint stake;
        uint endorsementCount;
        bool isTreasuryProposal;
        bool isAccepted;
    }

    Proposal[] public proposals;
    address public councilMember;

    event ProposalResult(bool indexed isAccepted, uint indexed proposalIndex);

    constructor(address _councilMember) {
        councilMember = _councilMember;
    }

    function propose(bool _isTreasuryProposal, uint INTToken) external payable {
        require(INTToken >= 10, "Minimum stake of 10 INT Tokens required");
        proposals.push(Proposal({
            proposer: msg.sender,
            stake: msg.value,
            endorsementCount: 0,
            isTreasuryProposal: _isTreasuryProposal,
            isAccepted: false
        }));
    }

    function finalizeProposal(uint256 _proposalIndex) external {
        require(_proposalIndex < proposals.length, "Invalid proposal index");
        require(msg.sender == councilMember, "Only council members can finalize proposals");
        Proposal storage proposal = proposals[_proposalIndex];

        if (proposal.endorsementCount > (proposals.length / 2) && !proposal.isAccepted) {
            if (proposal.isTreasuryProposal) {
                proposal.isAccepted = true;
                proposal.stake += (proposal.stake * 5) / 100;
            } else {
                proposal.isAccepted = true;
            }
            emit ProposalResult(true, _proposalIndex);
        } else {
            proposal.isAccepted = false;
            payable(proposal.proposer).transfer(proposal.stake);
            emit ProposalResult(false, _proposalIndex);
        }
    }
}

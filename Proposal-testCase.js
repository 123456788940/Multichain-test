const { expect } = require("chai");


describe("Proposal Contract", function () {
    let Proposal;
    let proposal;
    let owner;
    let addr1;
    let addrs;

    beforeEach(async function () {
        [owner, addr1, ...addrs] = await ethers.getSigners();
        Proposal = await ethers.getContractFactory("contractAddress");
        proposal = await Proposal.deploy(owner.address);
        await Proposal.deployed();

    });

    it("Should create a proposal with correct values", async function () {
        expect(await Proposal.councilMember()).to.equal(owner.address);

    });
    it("Should create a proposal with correct values", async function () {
        const isTreasuryProposal = true;
        const INTToken = 10;
        await proposal.propose(isTreasuryProposal, INTToken, {value:INTToken});
        
        
        const proposalInfo = await proposal.proposals(0);
        expect(proposalInfo.proposer).to.equal(owner.address);
        expect(proposalInfo.stake).to.equal(INTToken);
        expect(proposalInfo.endorsementCount).to.equal(0);
        expect(proposalInfo.isTreasuryProposal).to.equal(isTreasuryProposal);
        expect(proposalInfo.isAccepted).to.equal(false);



    });

    it("Should finalize a proposal correctly", async function () {
        const INTToken = 10;
        await proposal.propose(false, INTToken, {value: INTToken});
        await proposal.finalizeProposal(0);
        const proposalInfo = await proposal.proposals(0);
        expect(proposalInfo.isAccepted).to.equal(false);
    });


});

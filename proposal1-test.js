const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("proposal Contract", function () {
    let Proposal;
    let proposal;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    // Deploy the contract and get signers before running the tests
    beforeEach(async function (){
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        Proposal = await ethers.getContractFactory("Proposal");
        proposal = await Proposal.deploy(owner.address);
        await proposal.deployed();
    });

    it("Should create a proposal with correct values", async function () {
        const transactionId = ethers.utils.formatBytes32String();
        const amount = 1000;
        await proposal.proposeTransaction(amount, transactionId);
        const transactionInfo = await proposal.transactions(transactionId);
        expect(transactionInfo.proposed).to.equal(true);
        expect(transactionInfo.stake).to.equal(amount);
        expect(transactionInfo.proposer).to.equal(owner.address);
        expect(transactionInfo.finalized).to.equal(false);
        expect(transactionInfo.executed).to.equal(false);


    });

    it("Should finalize a proposal correctly", async function () {
        const transactionId = ethers.utils.formatBytes32String();
        const amount = 1500;
        await proposal.proposeTransaction(amount, transactionId);
        await proposal.finalizeProposal(amount, transactionId);
        const transactionInfo = await proposal.transactions(transactionId);
        expect(transactionInfo.finalized).to.equal(true);

    });

    it("Should execute a proposal correctly", async function () {
        const transactionId = ethers.utils.formatBytes32String();
        const amount = 2000;
        await proposal.proposeTransaction(amount, transactionId);
        await proposal.proposalAccepted(amount, transactionId);
        const transactionInfo = await proposal.transactions(transactionId);
        expect(transactionInfo.executed).to.equal(true);
    });
});

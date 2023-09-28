const { expect } = require("chai");


describe("Crowdfunding contract", function () {
    let crowdfunding;
    let owner;
    let contributor1;
    let contributor2;

    const fundingGoal = ethers.utils.parseEther("7");
    const durationInMinutes = 10;

    beforeEach(async function () {
        [owner, contributor1, contributor2] = await ethers.getSigners();
       const Crowdfunding = await ethers.getContractFactory("crowdfunding");
       crowdfunding= await Crowdfunding.deploy(fundingGoal, durationInMinutes);
       await crowdfunding.deployed();



    });


    it("Should set the owner correctly", async function () {
        expect(crowdfunding.owner()).to.equal(owner.address);


    });
    it("Should set the funding goal correctlty", async function () {
        expect(await crowdfunding.fundingGoal()).to.equal(fundingGoal);
    });


    it("Sould set the deadline correctly", async function () {
        const expectedDeadline = (await ethers.provider.getBlock("latest")).timestamp + durationInMinutes * 60;
        expect(await crowdfunding.deadline()).to.equal(expectedDeadline);

    });

});

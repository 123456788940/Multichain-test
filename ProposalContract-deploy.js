async function main() {
    const Proposal= await ethers.getContractFactory("_Proposal");
    const councilMember = ""; // put actual council member address
    const proposalContract = await Proposal.deploy(councilMember);

    await proposalContract.deployed();

    console.log("Proposal Contract deployed to:", proposalContract.address);


}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error)
    process.exit(1);
});

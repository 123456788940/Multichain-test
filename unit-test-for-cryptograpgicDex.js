const {expect} = require("chai");


describe("CryptographicDex Contract", function () {
let  CryptograhphicDex;
let cryptographicDex;
let owner;
let trader;
let receipt;
let orderId;
let encryptedOrder;

beforeEach(async function () {
    CryptograhphicDex = await ethers.getContractFactory("CryptograhphicDex");
    [owner, trader, receipt]=await ethers.getSigners();
    cryptographicDex = await  CryptograhphicDex.deploy();
    orderId=1;
    encryptedOrder="0x";

});

describe("Deployment", function (){
    it("Should set the right owner", async function (){
        const contractOwner = await cryptographicDex.owner();
        expect(await cryptographicDex.owner()).to.equal(owner.address);
    });
    it("Should place a trade order with encrypted details", async function () {
        const order = await cryptographicDex.tradeOrders(orderId);
        expect(order.trader).to.equal(trader.address);
        expect(order.encryptedOrder).to.equal(encryptedOrder);

    });

    it("Should share trade order with recipient", async function () {
        await cryptographicDex.connect(receipt).shareTradeOrder(orderId, receipt.address);
        const order = await cryptographicDex.tradeOrders(orderId);
        expect(order.trader).to.equal(trader.address);
        expect(order.encryptedOrder).to.equal(encryptedOrder);

    });
});

});

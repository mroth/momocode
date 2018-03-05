var EmojiHash = artifacts.require("./EmojiHash.sol");

const ex1_address = "0x583031D1113aD414F02576BD6afaBfb302140225";
const ex1_encoded = "🎉🍜🍝👊🌺🍦👍🌽👩🍎🎵🐴🎩💀🐶🐪🌅🌽🌅🍎";

contract("EmojiHash", async (accounts) => {

    it("should encode an address with expected output", async () => {
        let instance = await EmojiHash.deployed();
        let actual = await instance.encodeToStringDeprecated.call(ex1_address);
        assert.equal(actual, ex1_encoded);
    });

    it("should encode an address with expected output FASTER", async () => {
        let instance = await EmojiHash.deployed();
        let actual = await instance.encodeToString.call(ex1_address);
        assert.equal(actual, ex1_encoded);
    });

    it("should encode BLAH BLAH bytes", async () => {
        let instance = await EmojiHash.deployed();
        let actual = await instance.encode.call(ex1_address);
        console.log(actual);
        // assert.equal(actual, expected);
    });

});

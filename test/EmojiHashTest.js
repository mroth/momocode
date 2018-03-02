var EmojiHash = artifacts.require("./EmojiHash.sol");

contract("EmojiHash", async (accounts) => {

    it("should encode an address with expected output", async () => {
        let input = "0x583031D1113aD414F02576BD6afaBfb302140225";
        let expected = "🎉🍜🍝👊🌺🍦👍🌽👩🍎🎵🐴🎩💀🐶🐪🌅🌽🌅🍎";

        let instance = await EmojiHash.deployed();
        let actual = await instance.encodeToStringDeprecated.call(input);
        assert.equal(actual, expected);
    });

    it("should encode an address with expected output FASTER", async () => {
        let input = "0x583031D1113aD414F02576BD6afaBfb302140225";
        let expected = "🎉🍜🍝👊🌺🍦👍🌽👩🍎🎵🐴🎩💀🐶🐪🌅🌽🌅🍎";

        let instance = await EmojiHash.deployed();
        let actual = await instance.encodeToString.call(input);
        assert.equal(actual, expected);
    });

    it("should encode BLAH BLAH bytes", async () => {
        let input = "0x583031D1113aD414F02576BD6afaBfb302140225";
        let expected = "🎉🍜🍝👊🌺🍦👍🌽👩🍎🎵🐴🎩💀🐶🐪🌅🌽🌅🍎";

        let instance = await EmojiHash.deployed();
        let actual = await instance.encode.call(input);
        console.log(actual);
        // assert.equal(actual, expected);
    });

});

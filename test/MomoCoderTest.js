const crypto = require('crypto');
const MomoCoder = artifacts.require("./MomoCoder.sol");

const ex1_address = "0x583031D1113aD414F02576BD6afaBfb302140225";
const ex1_encoded = "🎉🍜🍝👊🌺🍦👍🌽👩🍎🎵🐴🎩💀🐶🐪🌅🌽🌅🍎";
const ex1_chunks = [
"0xf09f8e89", "0xf09f8d9c", "0xf09f8d9d", "0xf09f918a", "0xf09f8cba",
"0xf09f8da6", "0xf09f918d", "0xf09f8cbd", "0xf09f91a9", "0xf09f8d8e",
"0xf09f8eb5", "0xf09f90b4", "0xf09f8ea9", "0xf09f9280", "0xf09f90b6",
"0xf09f90aa", "0xf09f8c85", "0xf09f8cbd", "0xf09f8c85", "0xf09f8d8e"];

contract("MomoCoder", async (accounts) => {

    it("should encode an address to string with expected output", async () => {
        let instance = await MomoCoder.deployed();
        let actual = await instance.encodeToStringDeprecated.call(ex1_address);
        assert.equal(actual, ex1_encoded);
    });

    it("should encode an address to string with expected output FASTER", async () => {
        let instance = await MomoCoder.deployed();
        let actual = await instance.encodeToString.call(ex1_address);
        assert.equal(actual, ex1_encoded);
    });

    it("should encode to chunks for contract calls", async () => {
        let instance = await MomoCoder.deployed();
        let actual = await instance.encode.call(ex1_address);
        assert.deepEqual(actual, ex1_chunks);
    });

    it("should provide a convenience function for hashing digests", async () => {
        let instance = await MomoCoder.deployed();
        const data = "how much wood could a woodchuck chuck if a woodchuck could chuck wood?";
        const hash = crypto.createHash('ripemd160');
        hash.update(data);
        const prehash = "0x" + hash.digest('hex');
        let prehashed = await instance.encode.call(prehash);
        let actual = await instance.hashEncode.call(data);
        assert.deepEqual(prehashed, actual);
    });

    it("should provide a convenience function for hashing addresses to string", async () => {
        let instance = await MomoCoder.deployed();
        const srcAdr = Buffer.from(ex1_address.slice(2), 'hex');
        const hash = crypto.createHash('ripemd160');
        hash.update(srcAdr);
        const prehash = "0x" + hash.digest('hex');
        let prehashed = await instance.encodeToString.call(prehash);
        let actual = await instance.hashEncodeAddressToString.call(ex1_address);
        assert.equal(prehashed, actual);
    });

});

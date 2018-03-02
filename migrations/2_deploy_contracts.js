const EmojiHash = artifacts.require("./EmojiHash.sol")

module.exports = function(deployer) {
	deployer.deploy(EmojiHash);
};

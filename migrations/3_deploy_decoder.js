const MomoDecoder = artifacts.require("./MomoDecoder.sol")

module.exports = function(deployer) {
	deployer.deploy(MomoDecoder);
};

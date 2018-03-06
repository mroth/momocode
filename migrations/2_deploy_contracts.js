const MomoCoder = artifacts.require("./MomoCoder.sol")

module.exports = function(deployer) {
	deployer.deploy(MomoCoder);
};

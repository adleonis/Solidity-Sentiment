var Sentiment = artifacts.require("./Sentiment.sol");

module.exports = function(deployer) {
    deployer.deploy(Sentiment);
};

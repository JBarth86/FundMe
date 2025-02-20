// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// import AggregatorV3Interface from npm to interact with Chainlink Data Feeds
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    AggregatorV3Interface internal dataFeed;

    constructor() {

        /*
        Network: Sepolia
        Aggregator: ETH/USD
        Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        **/
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); 
    }

    function getPrice() public view returns (uint256) {
        
        (
            /*uint80 roundId*/,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();

        return uint256(answer * 1e10);
    }

    uint256 public minimumUSD = 5e18;

    function fund() public payable {
        
        uint256 dollarsSent = convertToDollars(msg.value);

        require(dollarsSent >= minimumUSD, "Didnt send enough ETH!");
    }

    function convertToDollars (uint256 eth) public view returns (uint256 amount){
        
        // Current price of ETH in USD with 18 decimal places
        uint256 price = getPrice();

        return price * eth / 1e18;
    
    }
}
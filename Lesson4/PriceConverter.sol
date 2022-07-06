// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.
// All the functions in library is internal

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter {
    // function to get conversion rate
    function getPrice() internal view returns(uint256) {
        // ABI Interface gives the minimum ABI
        // Address 	0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (, int256 price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD 8 decimals
        return uint256(price * 1e10);
    }


    // first argument goes as object 
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // Always multiple before you divide
        return ethAmountInUsd;
    }
}

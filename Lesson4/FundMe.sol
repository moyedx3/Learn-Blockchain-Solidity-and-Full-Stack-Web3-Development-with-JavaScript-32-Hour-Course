// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

// constant: declared & assigned together, immutable: declared & assigned differently

// 859,757
// 840,197

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    // 21,415 - constnat
    // 23,515 gas - non-constant
 
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    
    constructor() {
        // msg.sender of constructor functino is whoever deplys the contract
        i_owner = msg.sender;
    }
    
    // Smart contracts can hold funds as well as address
    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // 1e18 = 1 * 10 ** 18 
        // What is reverting?
        // Undo any action before, and send remaining gas back
        // 18 decimals

        // msg.sender = whoever calls this funciton
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        /* starting index, ending index, step amount */
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // reset the array
        funders = new address[](0);

        // actually withdraw the funds

        // transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);
        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call | most used
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender == i_owner) { revert NotOwner(); }
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

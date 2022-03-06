//SPDX-License-Identifier:MIT
pragma solidity >=0.6.0 < 0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


contract FundMe{
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmount;
    address[] public funders;
    address public owner;
    AggregatorV3Interface internal priceFeed;

    constructor() public{
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    function fund() public payable{
        uint256 minimumUSD = 1;
        require(getConversionRate(msg.value)>=minimumUSD,"You need to spend more ETH");
        addressToAmount[msg.sender]+=getConversionRate(msg.value);
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256){
        return priceFeed.version();
    }
    function getPrice() public view returns(uint256) {
        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function getConversionRate(uint256 weiAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 weiAmountInUSD = (weiAmount*ethPrice)/100000000000000000000000000;
        return weiAmountInUSD;
    }

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    function withdraw() public onlyOwner payable{
        msg.sender.transfer(address(this).balance);
        for(uint256 i = 0; i<funders.length;i++) addressToAmount[funders[i]]=0;
        funders = new address[](0);
    }
    
}
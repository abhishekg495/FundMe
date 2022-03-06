pragma solidity >= 0.6.0 < 0.9.0;
 
 contract SimpleStorage{
    uint256 public favNumber;

    function store(uint256 _favoriteNumber) public{
        favNumber = _favoriteNumber;
    }
 }
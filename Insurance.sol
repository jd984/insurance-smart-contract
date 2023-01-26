// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Insurance {
    address[] public policyholders;
    mapping(address => uint256) public policies;
    mapping(address => uint256) public claims;
    address payable owner;
    uint256 public totalPremium;

    constructor() {
        owner = payable(msg.sender);
    }

    function purchasePolicy (uint256 premium) public payable {
        require(msg.value == premium, "Incorrect amount");
        require(premium > 0, "Premium must be greater than 0");
        policyholders.push(msg.sender);
        policies[msg.sender] = premium;
        totalPremium += premium;
    }

    function approveClaim (address policyholder) public {
        require(msg.sender == owner, "Only owner can approve claims");
        require(claims[policyholder] > 0, "Policyholder has no outstanding claims");
        payable(policyholder).transfer(claims[policyholder]);
    }

    function getPolicy(address policyholder) public view returns (uint256) {
        return policies[policyholder];
    }

    function getClaim(address policyholder) public view returns (uint256) {
        return policies[policyholder];
    }

    function getTotalPremium() public view returns (uint256) {
        return totalPremium;
    }

    function grantAccess (address payable user) public {
        require(msg.sender == owner, "Only owner can grant access");
        owner = user;
    }

    function revokeAccess (address payable user) public {
        require(msg.sender == owner, "Only owner can grant access");
        require(user != owner, "cannot revoke acces for the current owner");
        owner = payable(msg.sender);
    }

    function destroy() public {
        require(msg.sender == owner, "Only owner can destroy contract");
        selfdestruct(owner);
    }
}
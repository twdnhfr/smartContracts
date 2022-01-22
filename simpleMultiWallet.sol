// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SimpleWallet is Ownable {
    mapping(address => uint256) funds; 

    receive() external payable {
        depositFunds();
    }

    function destroy() public payable onlyOwner {
        selfdestruct(payable(owner()));
    }

    function withdrawFunds(uint256 _amount) public payable {
        require(_amount <= address(this).balance, "Not enough in wallet");
        require(_amount <= funds[msg.sender], "Not enough allocated for you");

        funds[msg.sender] -= _amount;

        payable(msg.sender).transfer(_amount);
    }

    function changeAllocationForAddress(address _address, uint256 _amount) public onlyOwner {
        require(_amount >= 0);
        require(_amount <= getTotalBalance());

        funds[_address] = _amount;
    }

    function depositFunds() public payable {
        funds[msg.sender] += msg.value;
        funds[owner()] = address(this).balance;
    }

    function getTotalBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUserBalance() public view returns (uint256) {
        return funds[msg.sender];
    }
}

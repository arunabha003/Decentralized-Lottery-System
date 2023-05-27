// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery 
{
    address public Manager;
    address payable[] public participants;

    constructor()
    {
        Manager=msg.sender; //global variable
    }

    receive() external payable   
    {
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }

    function getbalance() public view returns(uint)
    {
        require(msg.sender==Manager);
        return address(this).balance;
    }

    function random() public view returns(uint)
    {
       return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }

    function selectWinner() public
    {
        require(msg.sender==Manager);
        require(participants.length>=3);
        uint r=random();
        address payable winner;
        uint index=r% participants.length;
        winner=participants[index];
        winner.transfer(getbalance());

        participants=new address payable[](0);
        
        }
}
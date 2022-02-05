// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable[] public players;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable{
        require(msg.value == 0.1 ether, "Required amount to enter the loterry is not received.");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == owner, "You are not the authorise user.");
        return address(this).balance;
    }

    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public{
        require(msg.sender == owner, "You are not the authorise user.");
        require(players.length >= 3, "Wait! Minimum numbers of plaers are not there.");

        unit r = random();
        address payable winner;

        uint index = r % players.length;
        winner = players[index];

        winner.transfer(getBalance());
        players = new address payable[](0); //resettting the lottery
    }

}
